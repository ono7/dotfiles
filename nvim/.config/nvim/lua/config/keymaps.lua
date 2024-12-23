local xpr = { noremap = true, expr = true }
local opt = { noremap = true }
local silent = { noremap = true, silent = true }

vim.keymap.set("n", "<space>", "")
vim.g.mapleader = " "

--- core keymaps ---
vim.keymap.set("i", "<C-a>", "<ESC>^i", silent)
vim.keymap.set("i", "<C-e>", "<End>", silent)

-- replaces vim surround
vim.cmd([[vnoremap ' <esc>`>a'<esc>`<i'<esc>`>2l]])
vim.cmd([[vnoremap " <esc>`>a"<esc>`<i"<esc>`>2l]])
vim.cmd([[vnoremap ` <esc>`>a`<esc>`<i`<esc>`>2l]])
vim.cmd([[vnoremap [ <esc>`>a]<esc>`<i[<esc>`>2l]])
vim.cmd([[vnoremap { <esc>`>a}<esc>`<i{<esc>`>2l]])
vim.cmd([[vnoremap ( <esc>`>a)<esc>`<i(<esc>`>2l]])

--- macros
vim.keymap.set("x", "Q", ":norm @q<CR>", opt)

--- quit it all
vim.keymap.set("n", "<leader>q", ":qa!<Cr>", opt)

-- Move within visual lines
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

--- nav improvement
vim.keymap.set("n", "0", "^", silent)

--- visual select last paste
vim.keymap.set("n", "gp", "`[v`]", silent)

--- keep cursor in same position when yanking in visual
vim.keymap.set("x", "y", [[ygv<Esc>]], silent)

vim.keymap.set("x", "H", "<gv", silent)
vim.keymap.set("x", "L", ">gv", silent)

-- Bind the function to a key mapping
vim.keymap.set("n", ",w", "<cmd>write<cr>", silent)
vim.keymap.set("n", ",q", "<cmd>q!<cr>", silent)
vim.keymap.set("n", ",x", "<cmd>x!<cr>", silent)
vim.keymap.set("n", ",d", "<cmd>bd<cr>", silent)

--- visual selection search ---
vim.keymap.set("v", "<enter>", [[y/\V<C-r>=escape(@",'/\')<CR><CR>]], silent)
vim.keymap.set("i", "<c-c>", "<Esc>", opt)

--- visual block by default
vim.keymap.set({ "n" }, "v", "<c-v>")

--- copy block
vim.keymap.set("n", "cp", "yap<S-}>p", opt)

--- ex/command mode bindings
vim.keymap.set("c", "<c-a>", "<Home>", opt)
vim.keymap.set("c", "<c-h>", "<Left>", opt)
vim.keymap.set("c", "<c-l>", "<Right>", opt)
vim.keymap.set("c", "<c-b>", "<S-left>", opt)

vim.keymap.set("n", "<leader>cd", function()
  vim.cmd.lcd("%:p:h")
  print("new lcd: " .. vim.fn.getcwd())
end, { silent = true })

--- paste over selection without overwriting clipboard
vim.keymap.set("x", "p", "pgvy")

--- leave unnnamed reg alone when changing text
vim.keymap.set("n", "c", '"ac')
vim.keymap.set("n", "C", '"aC')

-- Copy full file path
vim.keymap.set("n", "<leader>cp", ':let @+ = expand("%:p")<CR>', opt)

--- when using J keep cursor to the right
vim.keymap.set({ "n", "v" }, "J", "mzJ`z")

--- all others ---
-- vim.keymap.set("n", "+", ":e ~/todo.md<cr>", opt)

--- mapping tab also overrides c-i which is used to move through jump list
vim.keymap.set("n", "<m-]>", ":bnext<CR>", silent)
vim.keymap.set("n", "<m-[>", ":bprevious<CR>", silent)

-- make dot work in visual mode
vim.keymap.set("v", ".", ":norm .<cr>", opt)

--- nop ---
vim.keymap.set("n", "ZZ", "")
vim.keymap.set("n", "ZQ", "")

--- go ---
vim.keymap.set("n", "gt", ":GoTagAdd<cr>", silent)
vim.keymap.set("n", "gx", [[:sil !open <cWORD><cr>]], silent)

--- file ---

-- vim.keymap.set("n", "<leader>o", ":b#<CR>", { desc = "Previous buffer" })
vim.keymap.set("n", "gy", "`[v`]", { desc = "Select recently pasted, yanked or changed text" })
vim.keymap.set("n", "Y", "y$", opt)
vim.keymap.set("n", "U", "<c-r>", opt)

vim.keymap.set("x", ",a", ":!column -t<cr>")

--- terminal ---
vim.keymap.set("t", "<Esc>", [[<c-\><c-n>]], silent)

--- size 8, belowright split, T in commands.lua
vim.keymap.set({ "n" }, "<m-t>", ":T<CR>", { noremap = true, silent = true })
vim.keymap.set({ "i" }, "<m-t>", "<esc>:T<CR>", { noremap = true, silent = true })
vim.keymap.set("t", "<m-t>", [[<c-\><c-n>:T<CR>]], { noremap = true, silent = true })

vim.keymap.set("n", "<m-k>", "<cmd>cprev<cr>", opt)
vim.keymap.set("n", "<m-j>", "<cmd>cnext<cr>", opt)

-- vim.keymap.set("n", "'d", [[:%bd |e# |bd#<cr>|'"]], silent)

local function check_buf(bufnr)
  --- checks if this is a valid buffer that we can save to ---
  local bufname = vim.api.nvim_buf_get_name(bufnr)
  if bufname == "" then
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
  vim.fn.setpos(".", save_cursor)
  -- this is now handled by conform.nvim
end

vim.api.nvim_create_user_command("CleanAndSave", clean_space_save, {})

vim.keymap.set("n", "<leader>%", function()
  local path = vim.fn.expand("%:p")
  vim.fn.setreg("+", path)
  print("File path copied to clipboard: " .. path)
end, { noremap = true, silent = true, desc = "Copy file path to clipboard" })

-- vim.keymap.set("n", "<leaeder>w", ":write<CR>", { silent = true })

-- vim.keymap.set("n", ";", ":")
-- vim.keymap.set("n", ":", ";")

vim.keymap.set("n", "<leader>w", function()
  if not check_buf(0) then
    print("save me first!")
    return
  end
  local save_cursor = vim.fn.getcurpos()
  vim.cmd([[keeppatterns %s/\v\s*\r+$|\s+$//e]])
  -- this might cause issues with oil.nvim
  vim.cmd([[:write ++p]])
  vim.fn.setpos(".", save_cursor)
end, silent)

-- vim.keymap.set("n", "<leader>s", function()
--   if not check_buf(0) then
--     print("save me first!")
--     return
--   end
--   local save_cursor = vim.fn.getcurpos()
--   vim.cmd([[keeppatterns %s/\v\s*\r+$|\s+$//e]])
--   -- this might cause issues with oil.nvim
--   vim.cmd([[:write ++p]])
--   vim.fn.setpos(".", save_cursor)
-- end, silent)

-- local function hlsToggle()
--   if vim.opt.hlsearch then
--     vim.opt.hlsearch = false
--   else
--     vim.opt.hlsearch = true
--   end
-- end

-- hex stuff, just look away
-- vim.keymap.set(
--   "x",
--   "<space>h",
--   [[:s/\v\s+//ge<cr><bar> :s/\v(..)/\\\x\1/ge<cr><bar> :s/\v.*/buffer \+\= b"&"/ge<cr>:noh<cr>]],
--   silent
-- )

-- vim.keymap.set("i", "<c-e>", "<c-o>$", silent)
-- vim.keymap.set("i", "<c-a>", "<c-o>^", silent)

-- vim.keymap.set("n", "g(", [[?\v\w+.{-}\(\zs<cr>]])
-- vim.keymap.set("n", "g)", [[/\v\w+.{-}\(\zs<cr>]])
-- vim.keymap.set("n", "g{", "?{<cr>")
-- vim.keymap.set("n", "g}", "/}<cr>")
-- vim.keymap.set("n", "g[", [[?\v\[<cr>]])
-- vim.keymap.set("n", "g]", [[/\v\]<cr>]])

--- k("n", "<leader>t", [[:silent !tmux send-keys -t 2 c-p Enter<cr>]], silent)

vim.cmd([[ packadd cfilter ]]) -- quicklist filter :cfitler[!] /expression/

--- Optimized pair matching functions
local function is_pair(open, close)
  return (open == "(" and close == ")")
    or (open == "[" and close == "]")
    or (open == "{" and close == "}")
    or (open == "<" and close == ">")
    or (open == close and (open == "'" or open == '"' or open == "`"))
end

-- local api = vim.api
--
-- local function get_next_char()
--   local cursor = api.nvim_win_get_cursor(0)
--   local row, col = cursor[1], cursor[2]
--   return api.nvim_buf_get_text(0, row - 1, col, row - 1, col + 1, {})[1] or ""
-- end
--
-- vim.keymap.set("i", "]", function()
--   return get_next_char() == "]" and "<Right>" or "]"
-- end, { expr = true, silent = true })
--
-- vim.keymap.set("i", ")", function()
--   return get_next_char() == ")" and "<Right>" or ")"
-- end, { expr = true, silent = true })
--
-- vim.keymap.set("i", "}", function()
--   return get_next_char() == "}" and "<Right>" or "}"
-- end, { expr = true, silent = true })

vim.keymap.set("i", "<BS>", function()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  if col == 0 then
    return "<BS>" -- At the start of the line, just return a normal backspace
  end
  local chars = vim.api.nvim_buf_get_text(0, row - 1, col - 1, row - 1, col + 1, {})[1] or ""
  local prev_char, next_char = chars:sub(1, 1), chars:sub(2, 2)
  if is_pair(prev_char, next_char) then
    return "<Del><C-h>" -- Delete both characters
  else
    return "<BS>" -- Normal backspace behavior
  end
end, xpr)

--- these table and keymap below go together
-- local pair_map_2 = {
--   ["("] = ")",
--   ["["] = "]",
--   ["{"] = "}",
--   ["<"] = ">",
-- }

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
-- local enter_actions = {
--   ["("] = "<enter>)<Esc>O",
--   ["["] = "<enter>]<Esc>O",
--   ["{"] = "<enter>}<Esc>O",
--   ["<"] = "<enter>><Esc>O",
-- }
-- local default_enter = "<Enter>"
--
-- vim.keymap.set("i", "<enter>", function()
--   local row, col = unpack(vim.api.nvim_win_get_cursor(0))
--   local prev_char = ""
--   if col > 0 then
--     prev_char = vim.api.nvim_buf_get_text(0, row - 1, col - 1, row - 1, col, {})[1] or ""
--   end
--   return enter_actions[prev_char] or default_enter
-- end, { expr = true, silent = true })

-- vim.keymap.set("n", "f{", function()
--   vim.fn.search("{", "W")
-- end, { noremap = true, silent = true })
--
-- vim.keymap.set("n", "f(", function()
--   vim.fn.search("(", "W")
-- end, { noremap = true, silent = true })
--
-- vim.keymap.set("n", "f(", function()
--   vim.fn.search("(", "cW")
-- end, { noremap = true, silent = true })
--
-- vim.keymap.set("n", "f[", function()
--   vim.fn.search("[", "W")
-- end, { noremap = true, silent = true })
