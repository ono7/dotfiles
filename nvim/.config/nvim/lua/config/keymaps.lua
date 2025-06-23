local xpr = { noremap = true, expr = true }
local opt = { noremap = true }
local silent = { noremap = true, silent = true }

local neovide_or_macos = require("utils.keys")

vim.cmd([[
function! CopyMatches(reg)
  let hits = []
  %s//\=len(add(hits, submatch(0))) ? submatch(0) : ''/gne
  let reg = empty(a:reg) ? '+' : a:reg
  execute 'let @'.reg.' = join(hits, "\n") . "\n"'
endfunction
command! -register Cm call CopyMatches(<q-reg>)
]])

--- nop ---
vim.keymap.set("n", "ZZ", "")
vim.keymap.set("n", "ZQ", "")
vim.keymap.set("i", "<M-e>", "")
vim.keymap.set("i", "<M-C-U>", "")
vim.keymap.set("n", "<M-e>", "")

vim.keymap.set("n", "<space>", "")
vim.g.mapleader = " "

--- core keymaps ---
vim.keymap.set("i", neovide_or_macos.prefix("a"), "<ESC>^i", silent)
vim.keymap.set("i", neovide_or_macos.prefix("e"), "<End>", silent)

vim.keymap.set("i", "<M-a>", "<ESC>^i", silent)
vim.keymap.set("i", "<M-e>", "<End>", silent)

-- prevents matchit from mapping [%
vim.g.loaded_matchit = 1

-- vim.cmd([[vnoremap ' <esc>`>a'<esc>`<i'<esc>f'a]])
vim.cmd([[
vnoremap ' <esc>`>a"<esc>`<i"<esc>f"a
vnoremap ` <esc>`>a`<esc>`<i`<esc>f`a
cnoremap <c-a> <Home>
cnoremap <c-b> <left>
cnoremap <c-e> <end>
cnoremap <c-f> <right>
" cnoremap <c-h> <BS>
cnoremap <c-h> <Left>
cnoremap <c-l> <Right>

" <m-b>
cnoremap <esc>b <s-left>
" <m-f>
cnoremap <esc>f <s-right>
cnoremap <esc><backspace> <c-w>

inoremap <C-a> <Home>
inoremap <C-e> <End>
inoremap {<CR> {<CR>}<ESC>O

xnoremap H <gv
xnoremap L >gv

function! RestoreRegister()
    let @" = s:restore_reg
    return ''
endfunction
function! PasteOver()
     let s:restore_reg = @"
     return "p@=RestoreRegister()\<cr>"
endfunction
vnoremap <silent> <expr> p PasteOver()

autocmd BufReadPre * if getfsize(expand("%")) > 10000000 | setlocal noundofile nofoldenable | endif

function! s:CleanAndSave()
  let l:save = winsaveview()

  " Remove trailing whitespace and Windows ^M characters
  keeppatterns %s/\v\s*\r+$|\s+$//e

  " Remove empty lines at the end of the file
  keeppatterns %s#\($\n\s*\)\+\%$##e

  " Convert tabs to spaces (if expandtab is set)
  if &expandtab
    retab!
  endif

  call winrestview(l:save)
endfunction

augroup CleanOnWrite
  autocmd!
  autocmd BufWritePre * call s:CleanAndSave()
augroup end

augroup FileTypeSettings
  autocmd!

  " Python - 4 spaces
  autocmd FileType python setlocal tabstop=4 softtabstop=4 shiftwidth=4 expandtab

  " TypeScript/JavaScript/JSON/YAML - 2 spaces
  autocmd FileType typescript,javascript,markdown,typescriptreact,javascriptreact,json,yaml,yml setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab

  " Go - 4-width tabs
  autocmd FileType go setlocal tabstop=4 softtabstop=4 shiftwidth=4 noexpandtab

  " Shell scripts - 2 spaces
  autocmd FileType sh,bash,zsh setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab

  " Makefiles - tabs (required)
  autocmd FileType make setlocal tabstop=4 softtabstop=4 shiftwidth=4 noexpandtab

  " Jinja templates - 2 spaces
  autocmd FileType jinja,jinja2 setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
augroup end

augroup FormatPrg
  autocmd!
  if executable("black")
    autocmd FileType python setlocal formatprg=black\ --quiet\ -
  endif
  if executable("terraform")
    autocmd FileType terraform setlocal formatprg=terraform\ fmt\ -
  endif
  if executable("gofmt")
    autocmd FileType go setlocal formatprg=gofmt
  endif
  if executable("prettier")
    autocmd FileType markdown,javascript,typescript,json,css,html,yaml,scss setlocal formatprg=prettier\ --stdin-filepath=%
  endif
augroup end
]])

vim.keymap.set("n", "<TAB>", "%", opt)

---
vim.keymap.set("n", "<leader>dt", function()
  if vim.diagnostic.is_enabled() then
    vim.diagnostic.enable(false)
    print("diags: disabled")
  else
    vim.diagnostic.enable(true)
    print("diags: enabled")
  end
end)

--- macros
vim.keymap.set("x", "Q", ":norm @q<CR>", opt)

-- Move within visual lines
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

vim.keymap.set("n", "<space><space>", ":noh<cr>", silent)
-- vim.keymap.set("n", "<leader>b", ":buffer ", { desc = "Switch buffer by name" })

-- Select entire buffer content
vim.keymap.set("n", "<leader>a", "ggVG", { desc = "Select all" })

-- Quick paragraph operations
vim.keymap.set("n", "<leader>yp", "yap", { desc = "Yank paragraph" })

--- text navigation improvement
vim.keymap.set("n", "0", "^", silent)
vim.keymap.set("i", "<c-e>", "<c-o>$", silent)
vim.keymap.set("i", "<c-a>", "<c-o>^", silent)
vim.keymap.set("i", "<M-f>", "<C-o>w", opt)
vim.keymap.set("i", "<M-b>", "<C-o>b", opt)

--- visual select last paste
vim.keymap.set("n", "gp", "`[v`]", silent)

--- keep cursor in same position when yanking in visual
vim.keymap.set("x", "y", [[ygv<Esc>]], silent)

vim.keymap.set("x", "<", "<gv", silent)
vim.keymap.set("x", ">", ">gv", silent)

-- Bind the function to a key mapping
vim.keymap.set("n", ",d", "<cmd>bd!<cr>", silent)

-- notes
vim.keymap.set("n", "<leader>n", ":e ~/notes.md<cr>", silent)

--- visual selection search ---
vim.keymap.set("v", "<enter>", [[y/\V<C-r>=escape(@",'/\')<CR><CR>]], silent)
vim.keymap.set("i", neovide_or_macos.prefix("c"), "<Esc>", opt)

--- visual block by default
vim.keymap.set({ "n" }, "v", "<c-v>")

--- copy block
vim.keymap.set("n", "cp", "yap<S-}>p", opt)

--- ex/command mode bindings
vim.keymap.set("c", "<C-a>", "<Home>", opt)
vim.keymap.set("c", "<C-e>", "<End>", opt)
vim.keymap.set("c", "<C-h>", "<Left>", opt)
vim.keymap.set("c", "<C-l>", "<Right>", opt)
vim.keymap.set("c", "<C-b>", "<S-left>", opt)

vim.keymap.set("n", "<D-i>", "<c-i>", opt)
vim.keymap.set("n", "<D-o>", "<c-o>", opt)

vim.keymap.set("n", "<leader>cd", function()
  vim.cmd.lcd("%:p:h")
  print("new lcd: " .. vim.fn.getcwd())
end, { silent = true })

-- Copy full file path
vim.keymap.set("n", "<leader>cp", ':let @+ = expand("%:p")<CR>', opt)

--- when using J keep cursor to the right
vim.keymap.set({ "n", "v" }, "J", "mzJ`z")

-- make dot work in visual mode
vim.keymap.set("v", ".", ":norm .<cr>", opt)

--- go ---
-- vim.keymap.set("n", "gt", ":GoTagAdd<cr>", silent)
-- vim.keymap.set("n", "gx", [[:sil !open <cWORD><cr>]], silent)

--- file ---
vim.keymap.set("n", "<leader>bd", ":%bd|e#<cr>", silent)

vim.keymap.set("n", "gy", "`[v`]", { desc = "Select recently pasted, yanked or changed text" })
vim.keymap.set("n", "Y", "yg_", opt)
vim.keymap.set("n", "U", "<c-r>", opt)

vim.keymap.set("n", "<C-y>", function()
  if vim.t.maximized then
    vim.cmd("wincmd =")
    vim.t.maximized = false
  else
    vim.cmd("wincmd |")
    vim.cmd("wincmd _")
    vim.t.maximized = true
  end
end, { desc = "Toggle window maximize" })

vim.keymap.set("t", "<D-y>", function()
  if vim.t.maximized then
    vim.cmd("wincmd =")
    vim.t.maximized = false
  else
    vim.cmd("wincmd |")
    vim.cmd("wincmd _")
    vim.t.maximized = true
  end
end, { desc = "Toggle window maximize" })

vim.keymap.set("t", "<C-y>", function()
  if vim.t.maximized then
    vim.cmd("wincmd =")
    vim.t.maximized = false
  else
    vim.cmd("wincmd |")
    vim.cmd("wincmd _")
    vim.t.maximized = true
  end
end, { desc = "Toggle window maximize" })

vim.keymap.set("x", ",a", ":!column -t<cr>")

--- terminal ---
vim.keymap.set("t", "<M-BS>", "\x17", { noremap = true })

-- pass <c-b> to through term for tmux
vim.keymap.set("t", neovide_or_macos.prefix("b"), "<C-b>", { noremap = true })
vim.keymap.set("t", "<M-b>", "<C-b>", { noremap = true })

-- switch to normal mode
vim.keymap.set("t", "jj", [[<c-\><c-n>]], silent)
vim.keymap.set("t", "<M-t>", [[<c-\><c-n>:T<CR>]], silent)

vim.keymap.set("t", "<D-e>", [[<c-e>]], silent)
vim.keymap.set("t", "<D-d>", [[<c-d>]], silent)
vim.keymap.set("t", "<D-c>", [[<c-c>]], silent)
vim.keymap.set("t", "<D-p>", [[<c-p>]], silent)
vim.keymap.set("t", "<D-n>", [[<c-n>]], silent)
vim.keymap.set("t", "<D-r>", [[<c-r>]], silent)

vim.keymap.set({ "n" }, "<M-t>", ":T<CR>", silent)
vim.keymap.set({ "i" }, "<M-t>", [[<c-\><c-n>:T<CR>]], silent)

vim.keymap.set("n", "<M-k>", "<cmd>cprev<cr>", opt)
vim.keymap.set("n", "<M-j>", "<cmd>cnext<cr>", opt)

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

vim.keymap.set("i", "<M-BS>", "\x17", { noremap = true })
vim.api.nvim_create_user_command("CleanAndSave", clean_space_save, {})

vim.keymap.set("n", "<leader>%", function()
  local path = vim.fn.expand("%:p")
  vim.fn.setreg("+", path)
  print("File path copied to clipboard: " .. path)
end, { noremap = true, silent = true, desc = "Copy file path to clipboard" })

vim.keymap.set("n", ",w", function()
  if not check_buf(0) then
    print("save me first!")
    return
  end
  vim.cmd([[:write ++p]])
end, silent)

vim.keymap.set("n", "<leader>w", function()
  if not check_buf(0) then
    print("save me first!")
    return
  end
  vim.cmd([[:write ++p]])
end, silent)

vim.cmd([[ packadd cfilter ]]) -- quicklist filter :cfitler[!] /expression/

--- Optimized pair matching functions
local function is_pair(open, close)
  return (open == "(" and close == ")")
    or (open == "[" and close == "]")
    or (open == "{" and close == "}")
    or (open == "<" and close == ">")
    or (open == close and (open == "'" or open == '"' or open == "`"))
end

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

-- captures :messages to buffer
vim.keymap.set("n", "<Leader>m", function()
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_option(buf, "buftype", "nofile")
  vim.api.nvim_command("redir => g:message_capture")
  vim.api.nvim_command("silent messages")
  vim.api.nvim_command("redir END")
  local lines = vim.split(vim.g.message_capture, "\n")
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.api.nvim_command("vsplit")
  vim.api.nvim_win_set_buf(0, buf)
end)

vim.keymap.set("n", "<leader>sd", function()
  local project_name = vim.fn.getcwd():match("([^/]+)$")
  local session_path = sessions_dir .. "/" .. project_name .. ".vim"
  if vim.fn.filereadable(session_path) == 1 then
    vim.fn.delete(session_path)
    print("Session deleted: " .. session_path)
  else
    print("No session file found: " .. session_path)
  end
end, { desc = "Delete session" })

-- Toggle quickfix list
vim.keymap.set("n", "<C-t>", function()
  local qf_exists = false
  for _, win in pairs(vim.fn.getwininfo()) do
    if win["quickfix"] == 1 then
      qf_exists = true
      break
    end
  end
  if qf_exists == true then
    vim.cmd("cclose")
  else
    vim.cmd("copen")
  end
end, { desc = "Toggle quickfix list" })

-- show current function or class
vim.cmd([[
cnoremap <c-a> <Home>
cnoremap <c-b> <left>
cnoremap <c-e> <end>
cnoremap <c-f> <right>
" cnoremap <c-h> <BS>
cnoremap <c-h> <Left>
cnoremap <c-l> <Right>

" <m-b>
cnoremap <esc>b <s-left>
" <m-f>
cnoremap <esc>f <s-right>
cnoremap <esc><backspace> <c-w>

function! RestoreRegister()
    let @" = s:restore_reg
    return ''
endfunction
function! PasteOver()
     let s:restore_reg = @"
     return "p@=RestoreRegister()\<cr>"
endfunction
vnoremap <silent> <expr> p PasteOver()
]])

-- using mini.pairs
-- - these table and keymap below go together
-- local pair_map_2 = {
--   ["("] = ")",
--   ["["] = "]",
--   ["{"] = "}",
--   ["<"] = ">",
-- }
--
-- -- - optimized
-- vim.keymap.set("i", "<enter>", function()
--   local row, col = unpack(vim.api.nvim_win_get_cursor(0))
--   local prev_char = vim.api.nvim_buf_get_text(0, row - 1, col - 1, row - 1, col, {})[1] or ""
--   local closing_char = pair_map_2[prev_char]
--   if closing_char then
--     return "<enter>" .. closing_char .. "<Esc>O"
--   else
--     return "<Enter>"
--   end
-- end, { expr = true })
