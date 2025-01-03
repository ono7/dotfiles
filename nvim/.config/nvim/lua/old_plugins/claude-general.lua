local M = {}

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

local function call_claude_api(prompt, payload)
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
      -- model = 'claude-3-opus-20240229',
      model = 'claude-3-5-sonnet-20240620',
      max_tokens = 1000,
      messages = {
        { role = 'user', content = prompt .. '\n\n' .. payload }
      }
    })
  })
  if response.status ~= 200 then
    error('Failed to call Claude API: ' .. vim.inspect(response))
  end
  local body = vim.fn.json_decode(response.body)
  return body.content[1].text
end

local prompt_counter = 0
local function create_floating_window()
  local width = 60
  local height = 10
  local bufnr = vim.api.nvim_create_buf(false, true)
  local win_id = vim.api.nvim_open_win(bufnr, true, {
    relative = 'editor',
    width = width,
    height = height,
    col = (vim.o.columns - width) / 2,
    row = (vim.o.lines - height) / 2,
    style = 'minimal',
    border = 'rounded'
  })

  vim.api.nvim_buf_set_option(bufnr, 'buftype', 'acwrite')
  vim.api.nvim_buf_set_option(bufnr, 'filetype', 'markdown')

  prompt_counter = prompt_counter + 1
  local buf_name = string.format('Claude Prompt %d', prompt_counter)
  vim.api.nvim_buf_set_name(bufnr, buf_name)

  return bufnr, win_id
end

local function process_buffer()
  local original_bufnr = vim.api.nvim_get_current_buf()
  local prompt_bufnr, win_id = create_floating_window()

  local function on_buf_write()
    local prompt_lines = vim.api.nvim_buf_get_lines(prompt_bufnr, 0, -1, false)
    local prompt = table.concat(prompt_lines, '\n')

    local payload_lines = vim.api.nvim_buf_get_lines(original_bufnr, 0, -1, false)
    local payload = table.concat(payload_lines, '\n')

    vim.api.nvim_win_close(win_id, true)

    local result = call_claude_api(prompt, payload)

    vim.api.nvim_set_current_buf(original_bufnr)
    local line_count = vim.api.nvim_buf_line_count(original_bufnr)
    vim.api.nvim_buf_set_lines(original_bufnr, line_count, -1, false, vim.split(result, '\n'))
  end

  vim.api.nvim_create_autocmd("BufWriteCmd", {
    buffer = prompt_bufnr,
    callback = on_buf_write
  })
end

function M.setup()
  vim.api.nvim_create_user_command('ProcessBuffer', process_buffer, {})
end

return M
