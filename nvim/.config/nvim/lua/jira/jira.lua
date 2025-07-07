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

local function markdown_to_jira(markdown)
  local jira = markdown

  -- Headers
  jira = jira:gsub("^# (.-)%s*$", "h1. %1")
  -- jira = jira:gsub("^## (.-)%s*$", "h2. %1")
  -- jira = jira:gsub("^### (.-)%s*$", "h3. %1")

  jira = jira:gsub("^%d+%.(.-)%s*$", "- %1")

  -- Bold and Italic
  jira = jira:gsub("%*%*%*(.-)%*%*%*", "*%1*")
  jira = jira:gsub("%*%*(.-)%*%*", "*%1*")
  jira = jira:gsub("_(.-)_", "_%1_")

  -- Code blocks
  jira = jira:gsub("```(%w*)\n(.-)\n```", "{code:%1}\n%2\n{code}")

  -- Inline code
  jira = jira:gsub("`(.-)`", "{{%1}}")

  -- Unordered lists
  jira = jira:gsub("^%s*-%s(.-)%s*$", "* %1")

  -- Ordered lists
  jira = jira:gsub("^%s*(%d+)%.%s(.-)%s*$", "# %2")

  -- Links
  jira = jira:gsub("%[(.-)%]%((.-)%)", "[%1|%2]")

  return jira
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

function M.update_jira_story()
  M.setup()
  if not (config.jira_url and config.jira_email and config.jira_api_token) then
    print("Error: Jira plugin not properly configured, missing .env vars")
    return
  end

  -- Get the current buffer contents
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local content = table.concat(lines, '\n')

  local function preprocess_content(pre_content)
    -- Replace fenced code blocks with Jira code block syntax
    return pre_content:gsub("```(%w*)\n(.-)\n```", function(lang, code)
      return "{code:" .. lang .. "}\n" .. code .. "\n{code}"
    end)
  end

  --- fix code fenced blocks
  local preprocessed_content_1 = preprocess_content(content)

  --- fix markdown
  local preprocessed_content = markdown_to_jira(preprocessed_content_1)

  -- Get the current branch name and extract the issue key
  local branch_name = get_current_branch()
  local detected_issue_key = branch_name and extract_issue_key(branch_name) or nil

  -- Prompt for the Jira issue key, with the detected key as default
  local prompt = detected_issue_key
      and string.format("Jira issue (found: %s) or new: ", detected_issue_key)
      or "Enter Jira issue key: "
  local user_input = vim.fn.input(prompt)
  local issue_key = (user_input ~= "") and user_input or detected_issue_key

  if not issue_key:upper():match("^NTWK") then
    print("\nIssues must start with NTWK... your rules not mine")
    return
  end

  if not issue_key then
    print("Error: No valid issue key provided")
    return
  end

  -- Encode credentials
  local auth = vim.base64.encode(config.jira_email .. ':' .. config.jira_api_token)

  -- Make the API request
  local response = curl.post(config.jira_url .. '/rest/api/2/issue/' .. issue_key:upper() .. '/comment', {
    headers = {
      Authorization = 'Basic ' .. auth,
      ['Content-Type'] = 'application/json',
    },

    body = vim.fn.json_encode({ body = preprocessed_content }),
  })

  if response.status == 201 then
    print("")
    print('Successfully updated Jira story ' .. issue_key)
  else
    print('Failed to update Jira story. Status: ' .. response.status)
  end
end

-- Set up a command to call the function
vim.api.nvim_create_user_command('JiraUpdateStory', M.update_jira_story, {})

return M
