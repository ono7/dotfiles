local M = {}

local function get_git_diff()
  local job = require('plenary.job')
  local diff = job:new({
    command = 'git',
    args = { 'diff', '--staged' },
  }):sync()
  return table.concat(diff, '\n')
end

local function read_env_file()
  local home = os.getenv("HOME")
  local env_file = home .. "/.env"
  local env = {}
  for line in io.lines(env_file) do
    local key, value = line:match("^(.+)=(.+)$")
    if key and value then
      env[key] = value
    end
  end
  return env
end

local function call_claude_api(diff)
  local curl = require('plenary.curl')
  local env = read_env_file()
  local api_key = env.CLAUDE_API_KEY
  if not api_key then
    error("CLAUDE_API_KEY not found in ~/.env file")
  end
  local response = curl.post('https://api.anthropic.com/v1/messages', {
    headers = {
      ['Content-Type'] = 'application/json',
      ['X-API-Key'] = api_key,
      ['anthropic-version'] = '2023-06-01',
    },
    body = vim.fn.json_encode({
      model = 'claude-3-opus-20240229',
      max_tokens = 1000,
      messages = {
        { role = 'user', content = 'Please generate a concise and informative commit message for the following Git diff, do not explain what you are doing only provide the commit message it self, i will decide if its good, make sure to include feat(): fix: etc in the message\n\n' .. diff }
      }
    })
  })
  if response.status ~= 200 then
    error('Failed to call Claude API: ' .. vim.inspect(response))
  end
  local body = vim.fn.json_decode(response.body)
  return body.content[1].text
end

local function generate_commit_message()
  local diff = get_git_diff()
  if diff == '' then
    print('No staged changes found.')
    return
  end
  local commit_message = call_claude_api(diff)

  -- Insert the commit message at the current cursor position
  local current_line = vim.api.nvim_win_get_cursor(0)[1] - 1
  local lines = vim.split(commit_message, '\n')
  vim.api.nvim_buf_set_lines(0, current_line, current_line, false, lines)
end

function M.setup()
  vim.api.nvim_create_user_command('Commit', generate_commit_message, {})
end

return M
