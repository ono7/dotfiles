local api = vim.api
local fn = vim.fn
local curl = require('plenary.curl')

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

local function fetch_and_write_issues()
  if not setup() then
    return
  end

  -- Encode credentials
  local auth = vim.base64.encode(config.jira_email .. ':' .. config.jira_api_token)

  -- JQL query to get non-closed issues created by the current user and unassigned
  local jql = "creator = currentUser() AND status != Closed AND assignee = EMPTY"

  -- Make the API request to search for issues
  local response = curl.get(config.jira_url .. '/rest/api/2/search', {
    query = {
      jql = jql,
      fields = "key,summary,customfield_10020,parent,status"
    },
    headers = {
      Authorization = 'Basic ' .. auth,
      ['Content-Type'] = 'application/json',
    },
  })

  if response.status ~= 200 then
    display_message('Failed to fetch issues. Status: ' .. response.status, vim.log.levels.ERROR)
    return
  end

  local issues = vim.fn.json_decode(response.body).issues
  local sorted_issues = {}

  -- Collect and process issues
  for _, issue in ipairs(issues) do
    local epic = issue.fields.parent and issue.fields.parent.key or "No Epic"
    local sprint_name = ""
    local sprint_state = ""

    -- Check if customfield_10020 exists and has entries
    if issue.fields.customfield_10020 then
      if type(issue.fields.customfield_10020) == "table" then
        if #issue.fields.customfield_10020 > 0 then
          -- If it's an array, get the name and state of the most recent sprint (last in the array)
          local sprint = issue.fields.customfield_10020[#issue.fields.customfield_10020]
          sprint_name = sprint.name or ""
          sprint_state = sprint.state or ""
        elseif issue.fields.customfield_10020.name then
          -- If it's a single object, get the name and state directly
          sprint_name = issue.fields.customfield_10020.name
          sprint_state = issue.fields.customfield_10020.state or ""
        end
      elseif type(issue.fields.customfield_10020) == "string" then
        -- If it's a string, use it as the name (we can't determine state in this case)
        sprint_name = issue.fields.customfield_10020
      end
    end

    table.insert(sorted_issues, {
      key = issue.key:lower(),
      epic = epic,
      sprint = sprint_name,
      status = issue.fields.status.name,
      summary = issue.fields.summary
    })
  end

  -- Sort issues by sprint name
  table.sort(sorted_issues, function(a, b)
    return a.sprint < b.sprint
  end)

  -- Open the ~/.issues.txt file for writing
  local home = os.getenv("HOME")
  local file = io.open(home .. "/.issues.txt", "w")
  if not file then
    display_message("Error: Unable to open ~/.issues.txt for writing", vim.log.levels.ERROR)
    return
  end

  -- Write sorted issues to the file
  for _, issue in ipairs(sorted_issues) do
    local line = string.format("%s, %s, %s, %s, %s\n",
      issue.key,
      issue.epic,
      issue.sprint,
      issue.status,
      issue.summary
    )
    file:write(line)
  end

  file:close()
  display_message("Sorted issues have been written to ~/.issues.txt", vim.log.levels.INFO)
end

-- Function to open the main floating window
local function open_issues_window()
  fetch_and_write_issues()

  local issues_buf = api.nvim_create_buf(false, true)
  local width = math.floor(vim.o.columns * 0.6) -- 3/5 of screen width
  local height = math.floor(vim.o.lines * 0.6)  -- 3/5 of screen height
  local win_opts = {
    relative = 'editor',
    width = width,
    height = height,
    col = (vim.o.columns - width) / 2,
    row = (vim.o.lines - height) / 2,
    style = 'minimal',
    border = 'rounded'
  }
  local issues_win = api.nvim_open_win(issues_buf, true, win_opts)

  -- Read and set buffer contents
  local home = os.getenv("HOME")
  local issues = {}
  for line in io.lines(home .. "/.issues.txt") do
    table.insert(issues, line)
  end
  api.nvim_buf_set_lines(issues_buf, 0, -1, false, issues)

  -- Set buffer options
  api.nvim_buf_set_option(issues_buf, 'modifiable', false)
  api.nvim_buf_set_option(issues_buf, 'buftype', 'nofile')

  -- Set up keymap to close the window
  api.nvim_buf_set_keymap(issues_buf, 'n', 'q', ':lua vim.api.nvim_win_close(0, true)<CR>',
    { noremap = true, silent = true })

  -- Set up keymap to select an issue
  api.nvim_buf_set_keymap(issues_buf, 'n', '<CR>', ':lua select_issue()<CR>', { noremap = true, silent = true })
end

-- Function to handle issue selection
function select_issue()
  local line = api.nvim_get_current_line()
  vim.api.nvim_win_close(0, true)
  print("Selected issue: " .. line)
  -- You can replace the print statement with any other function call or logic
end

-- Command to open the issues window
api.nvim_create_user_command('JiraFetchUnassinged', open_issues_window, {})
