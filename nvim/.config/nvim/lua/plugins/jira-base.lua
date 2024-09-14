--- this will be resused on other code

-- Configuration
local config = {
  jira_url = nil,
  jira_email = nil,
  jira_api_token = nil
}

-- Helper function for displaying messages
local function display_message(message, level)
  level = level or vim.log.levels.INFO
  vim.schedule(function()
    vim.notify(message, level, { title = "Jira Plugin" })
  end)
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

local function setup()
  if not read_env_file() then
    display_message("Unable to read env file...", vim.log.levels.ERROR)
    return false
  end
  return true
end

-- Export the config and setup function for use in other modules
return {
  config = config,
  setup = setup,
  display_message = display_message
}
