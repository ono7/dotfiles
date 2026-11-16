local api = vim.api
local curl = require('plenary.curl')

local M = {}

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
    vim.notify(message, level, { title = "Jira Viewer" })
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

local function get_auth_header()
  return 'Basic ' .. vim.base64.encode(config.jira_email .. ':' .. config.jira_api_token)
end

local function fetch_issue_details(issue_key)
  local response = curl.get(config.jira_url .. '/rest/api/2/issue/' .. issue_key, {
    headers = {
      Authorization = get_auth_header(),
      ['Content-Type'] = 'application/json',
    },
  })

  if response.status ~= 200 then
    display_message('Failed to fetch issue details. Status: ' .. response.status, vim.log.levels.ERROR)
    return nil
  end

  local issue_data = vim.fn.json_decode(response.body)
  return issue_data.fields
end

local function update_issue_description(issue_key, description)
  local response = curl.put(config.jira_url .. '/rest/api/2/issue/' .. issue_key, {
    headers = {
      Authorization = get_auth_header(),
      ['Content-Type'] = 'application/json',
    },
    body = vim.fn.json_encode({
      fields = {
        description = description
      }
    }),
  })

  if response.status ~= 204 then
    display_message('Failed to update issue description. Status: ' .. response.status, vim.log.levels.ERROR)
    return false
  end

  display_message('Issue description updated successfully', vim.log.levels.INFO)
  return true
end

local function add_comment(issue_key, comment)
  local response = curl.post(config.jira_url .. '/rest/api/2/issue/' .. issue_key .. '/comment', {
    headers = {
      Authorization = get_auth_header(),
      ['Content-Type'] = 'application/json',
    },
    body = vim.fn.json_encode({
      body = comment
    }),
  })

  if response.status ~= 201 then
    display_message('Failed to add comment. Status: ' .. response.status, vim.log.levels.ERROR)
    return false
  end

  display_message('Comment added successfully', vim.log.levels.INFO)
  return true
end

local function open_issue_detail(issue_key)
  if not setup() then
    return
  end

  local issue_details = fetch_issue_details(issue_key)
  if not issue_details then
    return
  end

  -- Close the issues window if it exists
  if M.issues_win and api.nvim_win_is_valid(M.issues_win) then
    api.nvim_win_close(M.issues_win, true)
  end

  -- Create a new buffer for the issue details
  local buf = api.nvim_create_buf(false, true)
  api.nvim_buf_set_option(buf, 'buftype', 'acwrite')

  -- Prepare the content
  local content = {
    "Issue: " .. issue_key,
    "Summary: " .. issue_details.summary,
    "Status: " .. issue_details.status.name,
    "Assignee: " .. (issue_details.assignee and issue_details.assignee.displayName or "Unassigned"),
    "",
    "Description:",
    issue_details.description or "No description provided."
  }

  api.nvim_buf_set_lines(buf, 0, -1, false, content)

  -- Set up the floating window
  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)
  local win_opts = {
    relative = 'editor',
    width = width,
    height = height,
    col = (vim.o.columns - width) / 2,
    row = (vim.o.lines - height) / 2,
    style = 'minimal',
    border = 'rounded'
  }
  local win = api.nvim_open_win(buf, true, win_opts)

  -- Set buffer local options
  api.nvim_buf_set_option(buf, 'modifiable', true)
  api.nvim_buf_set_option(buf, 'filetype', 'markdown')

  -- Set buffer name
  api.nvim_buf_set_name(buf, "JIRA Issue: " .. issue_key)

  -- Set up autocmd to update the description when saving
  api.nvim_create_autocmd("BufWriteCmd", {
    buffer = buf,
    callback = function()
      local lines = api.nvim_buf_get_lines(buf, 6, -1, false) -- Skip the header lines
      local new_description = table.concat(lines, '\n')
      if update_issue_description(issue_key, new_description) then
        api.nvim_buf_set_option(buf, 'modified', false)
      end
    end,
  })

  -- Set up keymap to close the window
  api.nvim_buf_set_keymap(buf, 'n', 'q', ':lua vim.api.nvim_win_close(0, true)<CR>', { noremap = true, silent = true })

  -- Set up keymap to add a comment
  api.nvim_buf_set_keymap(buf, 'n', 'c', ':lua require("jira_viewer").open_comment_window()<CR>',
    { noremap = true, silent = true })

  -- Store the issue key in a buffer-local variable
  api.nvim_buf_set_var(buf, 'jira_issue_key', issue_key)
end

function M.open_comment_window()
  local issue_key = api.nvim_buf_get_var(0, 'jira_issue_key')
  if not issue_key then
    display_message("No Jira issue associated with this buffer", vim.log.levels.ERROR)
    return
  end

  -- Create a new buffer for the comment
  local comment_buf = api.nvim_create_buf(false, true)
  api.nvim_buf_set_option(comment_buf, 'buftype', 'acwrite')

  -- Open the buffer in a new floating window
  local width = math.floor(vim.o.columns * 0.4)
  local height = math.floor(vim.o.lines * 0.3)
  local win_opts = {
    relative = 'editor',
    width = width,
    height = height,
    col = (vim.o.columns - width) / 2,
    row = (vim.o.lines - height) / 2,
    style = 'minimal',
    border = 'rounded'
  }
  local comment_win = api.nvim_open_win(comment_buf, true, win_opts)

  -- Set buffer local options
  api.nvim_buf_set_option(comment_buf, 'modifiable', true)
  api.nvim_buf_set_option(comment_buf, 'filetype', 'markdown')

  -- Set buffer name
  api.nvim_buf_set_name(comment_buf, "JIRA Comment: " .. issue_key)

  -- Set up autocmd to add the comment when saving and closing
  api.nvim_create_autocmd("BufWriteCmd", {
    buffer = comment_buf,
    callback = function()
      local comment_text = table.concat(api.nvim_buf_get_lines(comment_buf, 0, -1, false), '\n')
      if add_comment(issue_key, comment_text) then
        api.nvim_buf_set_option(comment_buf, 'modified', false)
        api.nvim_win_close(comment_win, true)
      end
    end,
  })

  -- Set up keymap to close the window without saving
  api.nvim_buf_set_keymap(comment_buf, 'n', 'q', ':lua vim.api.nvim_win_close(0, true)<CR>',
    { noremap = true, silent = true })
end

function M.open_issues_file()
  if not setup() then
    return
  end

  local home = os.getenv("HOME")
  local issues_file = home .. "/.issues.txt"

  local issues = {}
  for line in io.lines(issues_file) do
    table.insert(issues, line)
  end

  -- Create a new buffer for the issues
  local buf = api.nvim_create_buf(false, true)
  api.nvim_buf_set_lines(buf, 0, -1, false, issues)

  -- Set up the floating window
  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)
  local win_opts = {
    relative = 'editor',
    width = width,
    height = height,
    col = (vim.o.columns - width) / 2,
    row = (vim.o.lines - height) / 2,
    style = 'minimal',
    border = 'rounded'
  }
  M.issues_win = api.nvim_open_win(buf, true, win_opts)

  -- Set buffer local options
  api.nvim_buf_set_option(buf, 'modifiable', false)
  api.nvim_buf_set_option(buf, 'filetype', 'markdown')

  -- Set buffer name
  api.nvim_buf_set_name(buf, "JIRA Issues")

  -- Set up keymap to open issue details
  api.nvim_buf_set_keymap(buf, 'n', '<CR>', ':lua require("jira_viewer").select_issue()<CR>',
    { noremap = true, silent = true })

  -- Set up keymap to close the window
  api.nvim_buf_set_keymap(buf, 'n', 'q', ':lua vim.api.nvim_win_close(0, true)<CR>', { noremap = true, silent = true })
end

function M.select_issue()
  local line = api.nvim_get_current_line()
  local issue_key = line:match("^([^,]+)")
  if issue_key then
    open_issue_detail(issue_key)
  else
    display_message("Invalid issue line format", vim.log.levels.ERROR)
  end
end

function M.setup()
  vim.api.nvim_create_user_command('JiraIssues', function()
    require('jira_viewer').open_issues_file()
  end, {})
end

return M
