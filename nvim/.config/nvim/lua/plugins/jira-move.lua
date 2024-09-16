local M = {}
local curl = require('plenary.curl')

-- Configuration
local config = {
  jira_url = nil,
  jira_email = nil,
  jira_api_token = nil
}

local transition_table = {
  ["Back to To Do"] = "back",
  ["To To Do"] = "todo",
  ["To Review"] = "review",
  ["To Done"] = "done",
  ["To In Progress"] = "wip",
}

local status_table = {
  back = "Back to To Do",
  todo = "To To Do",
  review = "To Review",
  done = "To Done",
  wip = "To In Progress"
}

local function transitions_to_string(tbl)
  local result = ""
  for _, v in ipairs(tbl) do
    result = result .. ", " .. v.name
  end
  return result
end

-- Helper function for displaying messages
local function display_message(message, level)
  level = level or vim.log.levels.INFO
  vim.schedule(function()
    vim.notify(message, level, { title = "Jira Plugin" })
  end)
end

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
  display_message("No issue key found in branch name", vim.log.levels.WARN)
  return nil
end

local function read_env_file()
  local home = os.getenv("HOME")
  local env_file = io.open(home .. "/.env", "r")
  if not env_file then
    display_message("Error: .env file not found in home directory", vim.log.levels.ERROR)
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
    display_message("Error: Missing .env vars JIRA_URL, JIRA_EMAIL or JIRA_API_TOKEN", vim.log.levels.ERROR)
    return false
  end
  return true
end

function M.setup()
  if not read_env_file() then
    display_message("Unable to read env file...", vim.log.levels.ERROR)
    return
  end
end

function M.move_issue(status, issue_key)
  M.setup()
  if not (config.jira_url and config.jira_email and config.jira_api_token) then
    display_message("Error: Jira plugin not properly configured, missing .env vars", vim.log.levels.ERROR)
    return
  end

  -- Get the current branch name and extract the issue key
  local branch_name = get_current_branch()
  local detected_issue_key = branch_name and extract_issue_key(branch_name) or nil

  if not issue_key then
    -- Prompt for the Jira issue key, with the detected key as default
    local prompt = detected_issue_key
        and string.format("Jira issue to move to %s (found: %s) or new: ", status:upper(), detected_issue_key)
        or string.format("Enter Jira issue key to move to %s: ", status:upper())
    local user_input = vim.fn.input(prompt)
    issue_key = (user_input ~= "") and user_input or detected_issue_key
  end

  if not issue_key then
    display_message("Error: No valid issue key provided", vim.log.levels.ERROR)
    return
  end

  -- TODO: add using %d+ and add ntwk to stream line
  if not issue_key:upper():match("^NTWK") then
    display_message("Issues must start with NTWK... your rules not mine", vim.log.levels.WARN)
    return
  end

  local last_chance = vim.fn.input(string.format("Move %s TO %s, (y/n?): ", issue_key, status:upper()))

  if last_chance ~= "y" then
    display_message("Operation cancelled by user", vim.log.levels.INFO)
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
    display_message('Failed to get transitions. Status: ' .. get_transitions_response.status, vim.log.levels.ERROR)
    return
  end

  local transitions = vim.fn.json_decode(get_transitions_response.body).transitions
  -- P(transitions)
  local transition_id

  for _, transition in ipairs(transitions) do
    if transition.name == status_table[status] then
      -- P({ status_table[status], transition.name })
      transition_id = transition.id
      break
    end
  end

  if not transition_id then
    display_message(
      string.format('E: "%s", invalid transition, valid transitions.', status:upper()),
      vim.log.levels.ERROR)
    display_message(transitions_to_string(transitions), vim.log.levels.INFO)
    return
  end

  -- Make the API request to move the issue
  local move_response = curl.post(config.jira_url .. '/rest/api/2/issue/' .. issue_key:upper() .. '/transitions', {
    headers = {
      Authorization = 'Basic ' .. auth,
      ['Content-Type'] = 'application/json',
    },
    body = vim.fn.json_encode({
      transition = {
        id = transition_id
      }
    }),
  })

  if move_response.status == 204 then
    display_message(string.format('Successfully moved Jira issue %s to %s', issue_key, status:upper()),
      vim.log.levels.INFO)
  else
    display_message(string.format('Failed to move Jira issue to %s. Status: %s', status:upper(), move_response.status),
      vim.log.levels.ERROR)
  end
end

--- takes just numbers for the issue
local function parse_issue(issue)
  if issue ~= nil then
    if issue:match("^%d") then
      return "NTWK-" .. issue
    elseif issue:match("^[Nn][Tt][Ww][Kk]%-%d+") then
      return issue
    end
  end
  return nil
end

-- Set up command to call the function with arguments
vim.api.nvim_create_user_command('JiraMove', function(opts)
  local a = vim.split(opts.args, "%s+")
  local status = a[1]
  local issue = nil
  if #a > 1 then
    issue = a[2]
  end
  if not status_table[status] then
    if not status:match("^%d+") or not status:match("[Nn][Tt][Ww][Kk]%-%d+") then
      P(status_table)
      return
    end
  end
  issue = parse_issue(issue)
  M.move_issue(status, issue)
end, { nargs = 1 })



return M
