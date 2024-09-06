local M = {}

local curl = require('plenary.curl')

-- Configuration
local config = {
  jira_url = nil,
  jira_email = nil,
  jira_api_token = nil
}

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
    print("Error: Missing required configuration in .env file")
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

  -- Prompt for the Jira issue key
  local issue_key = vim.fn.input('Enter Jira issue key: ')

  -- Encode credentials
  local auth = vim.base64.encode(config.jira_email .. ':' .. config.jira_api_token)

  -- Make the API request
  local response = curl.post(config.jira_url .. '/rest/api/2/issue/' .. issue_key:upper() .. '/comment', {
    headers = {
      Authorization = 'Basic ' .. auth,
      ['Content-Type'] = 'application/json',
    },
    body = vim.fn.json_encode({ body = content }),
  })

  if response.status == 201 then
    print('Successfully updated Jira story ' .. issue_key)
  else
    print('Failed to update Jira story. Status: ' .. response.status)
  end
end

-- Set up a command to call the function
vim.api.nvim_create_user_command('JiraUpdateStory', M.update_jira_story, {})

return M
