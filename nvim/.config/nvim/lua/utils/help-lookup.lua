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

-- Documentation function
local function open_documentation(is_visual)
  local filetype = vim.bo.filetype
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

  search_term = vim.fn.shellescape(search_term):gsub("'", "")

  local doc_urls = {
    javascript = string.format(
      "https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/%s",
      search_term
    ),
    python = string.format("https://docs.python.org/3/library/%s.html", string.lower(search_term)),
    rust = string.format("https://doc.rust-lang.org/std/?search=%s", search_term),
    go = string.format("https://pkg.go.dev/search?q=%s", search_term),
    lua = string.format("https://www.lua.org/manual/5.4/manual.html#pdf-%s", search_term),
    php = string.format(
      "https://www.php.net/manual/en/function.%s.php",
      string.lower(string.gsub(search_term, "_", "-"))
    ),
    java = string.format("https://docs.oracle.com/en/java/javase/11/docs/api/index.html?q=%s", search_term),
    ruby = string.format("https://ruby-doc.org/core-3.0.0/%s.html", search_term),
  }

  if is_visual then
    local search_url = string.format("https://www.google.com/search?q=%s+%s+documentation", search_term, filetype)
    open_url(search_url)
    return
  end

  local params = vim.lsp.util.make_position_params()
  vim.lsp.buf_request(0, "textDocument/hover", params, function(err, result, ctx, config)
    if result and result.contents then
      local content = result.contents.value or result.contents
      if type(content) == "string" then
        local url = string.match(content, "%(([^%)]+)%)")
        if url and (url:match("^http[s]?://") or url:match("^www%.")) then
          open_url(url)
          return
        end
      end
    end

    if doc_urls[filetype] then
      open_url(doc_urls[filetype])
    else
      local search_url = string.format("https://www.google.com/search?q=%s+%s+documentation", search_term, filetype)
      open_url(search_url)
    end
  end)
end

-- Setup function that creates the keymaps
function M.setup()
  local function normal_documentation()
    open_documentation(false)
  end

  local function visual_documentation()
    open_documentation(true)
  end

  vim.keymap.set("n", "H", normal_documentation, { noremap = true, silent = true })
  vim.keymap.set("v", "H", function()
    vim.cmd('normal! "vy')
    visual_documentation()
  end, { noremap = true, silent = true })
end

return M
