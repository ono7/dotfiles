local xpr = { noremap = true, expr = true }
local opt = { noremap = true }
local silent = { noremap = true, silent = true }

--- map leader ---
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- add movements bigger then 1 line to the jump list, but also navigate through wrapped lines
-- vim.cmd([[nnoremap <expr> j v:count ? (v:count > 1 ? "m'" . v:count : '') . 'j' : 'gj']])
-- vim.cmd([[nnoremap <expr> k v:count ? (v:count > 1 ? "m'" . v:count : '') . 'k' : 'gk']])
vim.keymap.set("n", "k", "gk", silent)
vim.keymap.set("n", "j", "gj", silent)

vim.g.mapleader = " "

--- nop ---
-- k("n", "<c-f>", "") -- use this for searching files
-- k("n", "<c-b>", "") -- allow tmux prefix to be used to jump to tmux pane
vim.keymap.set("n", "ZZ", "")
vim.keymap.set("n", "ZQ", "")


--- go ---
vim.keymap.set("n", "gt", ":GoTagAdd<cr>", silent)

-- k({ "n", "x" }, "<c-e>", "g_")
-- k({ "n", "x" }, [[\]], [[:vertical Git<cr>]], silent)

vim.keymap.set({ "n", "x" }, "\\", "<CMD>Neogit<CR>")

-- vim.keymap.set({ "n", "x" }, "\\", function()
--   -- Check if the current buffer's filetype is in the exclusion list
--   local excluded_filetypes = { "vim", "help", "" } -- Add more filetypes as needed
--   local current_filetype = vim.bo.filetype
--   for _, excluded in ipairs(excluded_filetypes) do
--     if current_filetype == excluded then
--       -- print("Fugitive toggle is disabled for " .. current_filetype .. " buffers.")
--       return
--     end
--   end
--
--   local fugitive_buf_found = false
--   local windows = vim.api.nvim_list_wins()
--   -- Check each window to see if it's showing a Fugitive buffer
--   for _, win in ipairs(windows) do
--     local buf = vim.api.nvim_win_get_buf(win)
--     local buf_name = vim.api.nvim_buf_get_name(buf)
--     if string.match(buf_name, "^fugitive://") then
--       fugitive_buf_found = true
--       -- Close the window that has the Fugitive buffer
--       vim.api.nvim_win_close(win, false)
--       break
--     end
--   end
--   -- If no Fugitive buffer was found, open Fugitive
--   if not fugitive_buf_found then
--     vim.cmd(":vertical Git")
--   end
-- end, { silent = true })
--
-- move selection to far left, far right
-- k("v", "gh", ":left<cr>", silent)
-- k("v", "gl", ":right<cr>", silent)

vim.keymap.set("n", "gx", [[:sil !open <cWORD><cr>]], silent)

vim.keymap.set("x", "H", "<gv", silent)
vim.keymap.set("x", "L", ">gv", silent)

-- toggle spell on and off
vim.keymap.set("n", "<leader>ss", function()
  vim.opt.spell = not vim.opt.spell
  print(vim.opt.spell._value)
end, silent)

local function check_buf(bufnr)
  --- checks if this is a valid buffer that we can save to ---
  local bufname = vim.api.nvim_buf_get_name(bufnr)
  if bufname == '' then
    return false
  end
  return true
end

local function clean_space_save()
  if not check_buf(0) then
    print("save me first!")
    return
  end
  local save_cursor = vim.fn.getcurpos()
  -- Fixes ^M chars from Windows copy-pastes and removes trailing spaces
  vim.cmd([[keeppatterns %s/\v\s*\r+$|\s+$//e]])
  vim.cmd([[:write ++p]])
  vim.fn.setpos('.', save_cursor)
  -- this is now handled by conform.nvim
end

vim.api.nvim_create_user_command('CleanAndSave', clean_space_save, {})

vim.keymap.set('n', '<leader>%', function()
  local path = vim.fn.expand('%:p')
  vim.fn.setreg('+', path)
  print('File path copied to clipboard: ' .. path)
end, { noremap = true, silent = true, desc = 'Copy file path to clipboard' })

vim.keymap.set("n", ",w", function()
  if not check_buf(0) then
    print("save me first!")
    return
  end
  local save_cursor = vim.fn.getcurpos()
  vim.cmd([[keeppatterns %s/\v\s*\r+$|\s+$//e]])
  -- this might cause issues with oil.nvim
  vim.cmd [[:write ++p]]
  vim.fn.setpos('.', save_cursor)
end, silent)

vim.keymap.set("n", "<leader>w", function()
  if not check_buf(0) then
    print("save me first!")
    return
  end
  local save_cursor = vim.fn.getcurpos()
  vim.cmd([[keeppatterns %s/\v\s*\r+$|\s+$//e]])
  -- this might cause issues with oil.nvim
  vim.cmd [[:write ++p]]
  vim.fn.setpos('.', save_cursor)
end, silent)

vim.keymap.set("n", ",d", "<cmd>bd<cr>", silent)

-- Bind the function to a key mapping
vim.keymap.set("n", ",q", "<cmd>q<cr>", silent)
vim.keymap.set("n", ",x", "<cmd>x!<cr>", silent)
vim.keymap.set("n", "<leader>x", "<cmd>x!<cr>", silent)
vim.keymap.set("n", "<leader>q", "<cmd>q<cr>", silent)
vim.keymap.set("n", "<leader>Q", "<cmd>q!<cr>", silent)
vim.keymap.set("n", ",Q", "<cmd>q!<cr>", silent)

--- navigation improvements ----
vim.keymap.set("n", "0", "^", silent)

--- navigate between splits ---
--- do not use with nvim tmux plugin ---
-- k("n", "<c-k>", "<C-W>k")
-- k("n", "<c-j>", "<C-W>j")
-- k("n", "<c-h>", "<C-W>h")
-- k("n", "<c-l>", "<C-W>l")

--- mapping tab also overrides c-i which is used to move through jump list
vim.keymap.set("n", "<m-]>", ":bnext<CR>", silent)
vim.keymap.set("n", "<m-[>", ":bprevious<CR>", silent)
-- k("n", "<leader>h", hlsToggle, silent)

--- make dot work in visual mode
vim.keymap.set("v", ".", ":norm .<cr>", opt)

--- macros
vim.keymap.set("x", "Q", ":norm @q<CR>", opt)

local function hlsToggle()
  if vim.opt.hlsearch then
    vim.opt.hlsearch = false
  else
    vim.opt.hlsearch = true
  end
end

-- hex stuff, just look away
-- m(
--   "x",
--   "<space>h",
--   [[:s/\v\s+//ge<cr><bar> :s/\v(..)/\\\x\1/ge<cr><bar> :s/\v.*/buffer \+\= b"&"/ge<cr>:noh<cr>]],
--   silent
-- )

--- copy block
vim.keymap.set("n", "cp", "yap<S-}>p", opt)

--- ex/command mode bindings
vim.keymap.set("c", "<c-a>", "<Home>", opt)
vim.keymap.set("c", "<c-h>", "<Left>", opt)
vim.keymap.set("c", "<c-l>", "<Right>", opt)
vim.keymap.set("c", "<c-b>", "<S-left>", opt)

vim.keymap.set("i", "<c-e>", "<c-o>$", silent)
vim.keymap.set("i", "<c-a>", "<c-o>^", silent)
-- k("n", "<c-e>", "$", silent)
-- k("n", "<c-a>", "^", silent)
vim.keymap.set("n", "g(", [[?\v\w+.{-}\(\zs<cr>]])
vim.keymap.set("n", "g)", [[/\v\w+.{-}\(\zs<cr>]])
vim.keymap.set("n", "g{", "?{<cr>")
vim.keymap.set("n", "g}", "/}<cr>")
vim.keymap.set("n", "g[", [[?\v\[<cr>]])
vim.keymap.set("n", "g]", [[/\v\]<cr>]])

--- tmux ---
-- TODO(jlima): fix this
--- k("n", "<leader>t", [[:silent !tmux send-keys -t 2 c-p Enter<cr>]], silent)
vim.keymap.set("n", "<leader>t", [[:botright 6sp term://zsh<CR>]], silent)

--- visual selection search ---
vim.keymap.set("v", "<enter>", [[y/\V<C-r>=escape(@",'/\')<CR><CR>]], silent)

--- marks/jumps ---
--- k("n", "'", "`", opt)
-- k("n", "mm", "mM", opt)
-- k("n", "'m", [[`M'\"]], opt)
vim.keymap.set("n", "ma", "mA", opt)
vim.keymap.set("n", "mB", "mB", opt)
vim.keymap.set("n", "'a", [[`A'\"]], opt)
vim.keymap.set("n", "'b", [[`B'\"]], opt)

vim.keymap.set("i", "<C-c>", "<Esc>", opt)
vim.keymap.set("n", "Y", "y$", opt)

vim.keymap.set("n", "U", "<c-r>", opt)

--- keep cursor in the middle when using search
vim.keymap.set("n", "<C-d>", "<C-d>zz", opt)
vim.keymap.set("n", "<C-u>", "<C-u>zz", opt)

--- paste over selection without overwriting clipboard
vim.keymap.set("x", "p", "pgvy")

--- leave unnnamed reg alone when changing text
vim.keymap.set("n", "c", '"ac')
vim.keymap.set("n", "C", '"aC')

--- when using J keep cursor to the right
vim.keymap.set({ "n", "v" }, "J", "mzJ`z")

--- terminal ---
vim.keymap.set("t", "<Esc>", [[<c-\><c-n>]], silent)

--- visual block by default
vim.keymap.set({ "n" }, "v", "<c-v>")
--- vim.cmd("vunmap v")

vim.cmd([[ packadd cfilter ]]) -- quicklist filter :cfitler[!] /expression/
vim.keymap.set("n", "]n", "<cmd>cprev<cr>", opt)
vim.keymap.set("n", "[n", "<cmd>cnext<cr>", opt)

--- Optimized pair matching functions
local function is_pair(open, close)
  return (open == '(' and close == ')') or
      (open == '[' and close == ']') or
      (open == '{' and close == '}') or
      (open == '<' and close == '>') or
      (open == close and (open == "'" or open == '"' or open == '`'))
end

local function is_quote(char)
  return char == "'" or char == '"' or char == '`'
end

local function is_bracket(char)
  return char == '(' or char == '[' or char == '{' or char == '<'
end

local function is_close_bracket(char)
  return char == ')' or char == ']' or char == '}' or char == '>'
end

local function is_closing_char(char)
  return is_close_bracket(char) or is_quote(char) or char == ' '
end

--- for reference using vim script functions
-- local function get_next_and_prev_chars()
--   -- returns p, n
--   local col = vim.fn.col('.')
--   local line = vim.fn.getline('.')
--   return line:sub(col - 1, col - 1), line:sub(col, col)
-- end

-- --- gets only next char
-- local function get_next_char()
--   -- returns next char
--   local line = vim.api.nvim_get_current_line()
--   local col = vim.api.nvim_win_get_cursor(0)[2] + 1 -- Column is 0-indexed, add 1 for Lua string indexing
--   return line:sub(col, col)
-- end

--- returns previous and next characters respectively
-- local function get_next_and_prev_chars()
--   local line = vim.api.nvim_get_current_line()
--   local col = vim.api.nvim_win_get_cursor(0)[2] + 1 -- Column is 0-indexed, add 1 for Lua string indexing
--   return line:sub(col - 1, col - 1), line:sub(col, col)
-- end

-- Returns previous and next characters using Neovim API with a single call
-- This optimizes performance by fetching both characters in one API call

local function get_next_and_prev_chars()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local chars = vim.api.nvim_buf_get_text(0, row - 1, col - 1, row - 1, col + 1, {})[1] or ''
  return chars:sub(1, 1), chars:sub(2, 2)
end

local function get_next_char()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local next_char = vim.api.nvim_buf_get_text(0, row - 1, col, row - 1, col + 1, {})[1] or ''
  return next_char
end

-- Function to handle '"'
-- k('i', '"', function()
--   local p, n = get_next_and_prev_chars()
--   if n == '"' then
--     return '<Right>'
--   elseif (p and p:match("%w")) or (n and n:match("%w")) then
--     return '"'
--   else
--     return '""<left>'
--   end
-- end, { expr = true })

-- Function to handle "'" (similar logic)
-- k('i', "'", function()
--   local p, n = get_next_and_prev_chars()
--   if n == "'" then
--     return '<Right>'
--   elseif (p and p:match("%w")) or (n and n:match("%w")) then
--     return "'"
--   else
--     return "''<left>"
--   end
-- end, { expr = true })

---- handle {}
-- k('i', '[', function()
--   local n = get_next_char()
--   if r_pair_map[n] then
--     return '[]<Left>'
--   elseif n ~= '' then
--     return '['
--   end
--   return '[]<Left>'
-- end, { expr = true })

vim.keymap.set('i', ']', function()
  local n = get_next_char()
  if n == ']' then
    return '<Right>'
  end
  return ']'
end
, { expr = true, silent = true })

---- handle {}
-- k('i', '{', function()
--   local n = get_next_char()
--   if r_pair_map[n] then
--     return '{}<Left>'
--   elseif n ~= '' then
--     return '{'
--   end
--   return '{}<Left>'
-- end, { expr = true })

vim.keymap.set('i', '}', function()
  local n = get_next_char()
  if n == '}' then
    return '<Right>'
  end
  return '}'
end
, { expr = true, silent = true })

-- handle (
-- k('i', '(', function()
--   local n = get_next_char()
--   if r_pair_map[n] then
--     return '()<Left>'
--   elseif n ~= '' then
--     return '('
--   end
--   return '()<Left>'
-- end, { expr = true })

vim.keymap.set({ 'i' }, ')', function()
  local n = get_next_char()
  if n == ')' then
    return '<Right>'
  end
  return ')'
end
, { expr = true, silent = true })

-- k('i', '>', function()
--   local n = get_next_char()
--   if n == '>' then
--     return '<Right>'
--   end
--   return '>'
-- end
-- , { expr = true })

vim.keymap.set("i", "<BS>", function()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  if col == 0 then
    return "<BS>" -- At the start of the line, just return a normal backspace
  end
  local chars = vim.api.nvim_buf_get_text(0, row - 1, col - 1, row - 1, col + 1, {})[1] or ''
  local prev_char, next_char = chars:sub(1, 1), chars:sub(2, 2)
  if is_pair(prev_char, next_char) then
    return "<Del><C-h>" -- Delete both characters
  else
    return "<BS>"       -- Normal backspace behavior
  end
end, xpr)

local pair_map_2 = {
  ["("] = ")",
  ["["] = "]",
  ["{"] = "}",
  ["<"] = ">",
}

--- optimized
-- k("i", "<enter>", function()
--   local row, col = unpack(vim.api.nvim_win_get_cursor(0))
--   local prev_char = vim.api.nvim_buf_get_text(0, row - 1, col - 1, row - 1, col, {})[1] or ''
--   local closing_char = pair_map_2[prev_char]
--   if closing_char then
--     return "<enter>" .. closing_char .. "<Esc>O"
--   else
--     return "<Enter>"
--   end
-- end, { expr = true })

--- Optimized Enter key actions using a lookup table
local enter_actions = {
  ["("] = "<enter>)<Esc>O",
  ["["] = "<enter>]<Esc>O",
  ["{"] = "<enter>}<Esc>O",
  ["<"] = "<enter>><Esc>O",
}
local default_enter = "<Enter>"

vim.keymap.set("i", "<enter>", function()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local prev_char = vim.api.nvim_buf_get_text(0, row - 1, col - 1, row - 1, col, {})[1] or ''
  return enter_actions[prev_char] or default_enter
end, { expr = true, silent = true })

--- delete all but the current buffer
vim.keymap.set("n", "'d", [[:%bd |e# |bd#<cr>|'"]], silent)
