local M = {}
local curl = require('plenary.curl')

-- Configuration
local config = {
  jira_url = nil,
  jira_email = nil,
  jira_api_token = nil
}

local function get_current_branch()
  local handle = io.popen("git branch --show-current")
  if handle then
    local result = handle:read("*a")
    handle:close()
    return result:gsub("^%s*(.-)%s*$", "%1") -- Trim whitespace
  end
  return nil
end

local function extract_issue_key(branch_name)
  -- Case-insensitive match for "ntwk-" followed by numbers
  local issue_key = branch_name:match("[Nn][Tt][Ww][Kk]%-%d+")
  if issue_key then
    return issue_key
  end
  print("No issue key found in branch name")
  return nil
end

local function read_env_file()
  local home = os.getenv("HOME")
  local env_file = io.open(home .. "/.env", "r")
  if not env_file then
    print("Error: .env file not found in home directory")
    return false
  end
  for line in env_file:lines() do
    local key, value = line:match("^([%w_]+)%s*=%s*(.+)$")
    if key and value then
      if key == "JIRA_URL" then
        config.jira_url = value
      elseif key == "JIRA_EMAIL" then
        config.jira_email = value
      elseif key == "JIRA_API_TOKEN" then
        config.jira_api_token = value
      end
    end
  end
  env_file:close()
  if not (config.jira_url and config.jira_email and config.jira_api_token) then
    print("Error: Missing .env vars JIRA_URL, JIRA_EMAIL or JIRA_API_TOKEN")
    return false
  end
  return true
end

function M.setup()
  if not read_env_file() then
    print("Failed to set up Jira plugin due to configuration errors")
    return
  end
end

function M.move_to_done()
  M.setup()
  if not (config.jira_url and config.jira_email and config.jira_api_token) then
    print("Error: Jira plugin not properly configured, missing .env vars")
    return
  end

  -- Get the current branch name and extract the issue key
  local branch_name = get_current_branch()
  local detected_issue_key = branch_name and extract_issue_key(branch_name) or nil

  -- Prompt for the Jira issue key, with the detected key as default
  local prompt = detected_issue_key
      and string.format("Jira issue to move to DONE (found: %s) or new: ", detected_issue_key)
      or "Enter Jira issue key to move to DONE: "
  local user_input = vim.fn.input(prompt)
  local issue_key = (user_input ~= "") and user_input or detected_issue_key

  if not issue_key then
    print("Error: No valid issue key provided")
    return
  end

  -- Encode credentials
  local auth = vim.base64.encode(config.jira_email .. ':' .. config.jira_api_token)

  -- First, get the available transitions for the issue
  local get_transitions_response = curl.get(
    config.jira_url .. '/rest/api/2/issue/' .. issue_key:upper() .. '/transitions', {
      headers = {
        Authorization = 'Basic ' .. auth,
        ['Content-Type'] = 'application/json',
      },
    })

  if get_transitions_response.status ~= 200 then
    print('Failed to get transitions. Status: ' .. get_transitions_response.status)
    return
  end

  local transitions = vim.fn.json_decode(get_transitions_response.body).transitions
  local done_transition_id

  for _, transition in ipairs(transitions) do
    -- P(transition)
    if transition.name:lower() == "to done" then
      done_transition_id = transition.id
      break
    end
  end

  if not done_transition_id then
    print('Error: Could not find a "Done" transition for this issue')
    return
  end

  -- Make the API request to move the issue to DONE
  local move_response = curl.post(config.jira_url .. '/rest/api/2/issue/' .. issue_key:upper() .. '/transitions', {
    headers = {
      Authorization = 'Basic ' .. auth,
      ['Content-Type'] = 'application/json',
    },
    body = vim.fn.json_encode({
      transition = {
        id = done_transition_id
      }
    }),
  })

  if move_response.status == 204 then
    print("")
    print('Successfully moved Jira issue ' .. issue_key .. ' to DONE')
  else
    print('Failed to move Jira issue to DONE. Status: ' .. move_response.status)
  end
end

-- Set up commands to call the functions
vim.api.nvim_create_user_command('JiraMoveToDone', M.move_to_done, {})

return M
