-- Create the module
local M = {}

-- Function to open URL based on OS
local function open_url(url)
  local os_name = vim.loop.os_uname().sysname
  local cmd
  if os_name == "Darwin" then -- macOS
    cmd = { "open", url }
  elseif os_name == "Linux" then
    cmd = { "xdg-open", url }
  elseif os_name == "Windows_NT" then
    cmd = { "cmd", "/c", "start", url }
  else
    print("Unsupported operating system")
    return
  end
  vim.fn.jobstart(cmd)
end

-- Function to get visual selection
local function get_visual_selection()
  local _, start_line, start_col, _ = unpack(vim.fn.getpos("'<"))
  local _, end_line, end_col, _ = unpack(vim.fn.getpos("'>"))
  local lines = vim.fn.getline(start_line, end_line)
  if #lines == 0 then
    return ""
  end
  if #lines == 1 then
    lines[1] = string.sub(lines[1], start_col, end_col)
  else
    lines[1] = string.sub(lines[1], start_col)
    lines[#lines] = string.sub(lines[#lines], 1, end_col)
  end
  local text = table.concat(lines, " ")
  return string.gsub(text, "^%s*(.-)%s*$", "%1")
end

-- Google search function
local function google_search(is_visual)
  local search_term

  if is_visual then
    search_term = get_visual_selection()
    if search_term == "" then
      print("No text selected")
      return
    end
  else
    search_term = vim.fn.expand("<cword>")
  end

  -- URL encode the search term
  search_term = vim.fn.shellescape(search_term):gsub("'", "")

  -- Create Google search URL
  local search_url = string.format("https://www.google.com/search?q=%s", search_term)
  open_url(search_url)
end

-- Setup function that creates the keymaps
function M.setup()
  local function normal_search()
    google_search(false)
  end

  local function visual_search()
    google_search(true)
  end

  -- vim.keymap.set("n", "H", normal_search, { noremap = true, silent = true })
  -- vim.keymap.set("v", "H", function()
  --   vim.cmd('normal! "vy')
  --   visual_search()
  -- end, { noremap = true, silent = true })
end

return M
