-- local xpr = { noremap = true, expr = true }
local opt = { noremap = true }
local silent = { noremap = true, silent = true }

local k = vim.keymap.set

--- nop ---
k({ "n", "i", "v", "t" }, "<D-q>", "")
k("n", "ZZ", "")
k("n", "ZQ", "")
k("i", "<M-e>", "")
k("i", "<M-C-U>", "")
k("n", "<M-e>", "")

k("n", "<space>", "")
vim.g.mapleader = " "

k("i", "<c-y>", "<c-x><c-n>", silent)

k("i", "<M-a>", "<ESC>^i", silent)
k("i", "<M-e>", "<End>", silent)

-- prevents matchit from mapping [%
vim.g.loaded_matchit = 1

vim.cmd([[

command! Mktags call system('ctags -R .')

cnoreabbrev qq qa!

map Q <Nop>

cnoremap <c-a> <Home>
cnoremap <c-b> <left>
cnoremap <c-e> <end>
nnoremap <c-e> <end>
cnoremap <c-l> <Right>

inoremap <C-BS> <C-w>
inoremap <C-a> <C-o>^
inoremap <C-e> <End>
inoremap <C-f> <Esc>ea
inoremap <C-b> <C-o>b
inoremap <C-d> <C-o>D
inoremap <C-p> <C-r>"
nnoremap <C-n> <cmd>tabnew<cr>

nnoremap ; :
xnoremap ; :
nnoremap D d$
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'
nnoremap <silent> <space><space> <cmd>noh<cr>
nnoremap <space>a ggVG
nnoremap U <c-r>
" nnoremap v <c-v>
nnoremap Y yg_

nnoremap j gj
nnoremap k gk

" xnoremap p P
xnoremap p "_dP

" make dot operator work in visual mode
xnoremap . :<C-u>normal! .<CR>

" clear hlsearch on esc
" nnoremap <silent> <Esc> :noh<CR><Esc>

"nnoremap <esc>k <cmd>cprev<cr>
"nnoremap <esc>j <cmd>cnext<cr>

" nnoremap gm :Git add % <bar> Git commit % -m ""<Left>
nnoremap gm :Git add % <bar> Git commit % -m "<C-r>=expand('%:t')<CR>: "<Left>

nnoremap <leader>d <cmd>%bd!\|e#\|bd!#<CR>
nnoremap ,d <cmd>bd!<CR>
nnoremap <leader>x <cmd>x<CR>
nnoremap <leader>td <cmd>e ~/todo.md<CR>

xnoremap H <gv
xnoremap L >gv
xnoremap y ygv<Esc>

function! WrapSelection(left, right)
    let save_reg = @"
    normal! `
    call search('\S', 'c')
    let start_pos = getpos('.')
    normal! `>
    let end_pos = getpos('.')

    call setpos('.', end_pos)
    execute "normal! a" . a:right
    call setpos('.', start_pos)
    execute "normal! i" . a:left
    let @" = save_reg
    startinsert
endfunction

xnoremap ' :<C-u>call WrapSelection("'", "'")<CR>
xnoremap " :<C-u>call WrapSelection('"', '"')<CR>
xnoremap ` :<C-u>call WrapSelection('`', '`')<CR>
xnoremap ( :<C-u>call WrapSelection('(', ')')<CR>
xnoremap [ :<C-u>call WrapSelection('[', ']')<CR>
" xnoremap { :<C-u>call WrapSelection('{', '}')<CR>
xnoremap < :<C-u>call WrapSelection('<', '>')<CR>

set iskeyword+=_,-
set ttyfast

function! CopyMatches(reg)
  let hits = []
  %s//\=len(add(hits, submatch(0))) ? submatch(0) : ''/gne
  let reg = empty(a:reg) ? 'c' : a:reg
  execute 'let @'.reg.' = join(hits, "\n") . "\n"'
endfunction
command! -register Cm call CopyMatches(<q-reg>)

function! RestoreRegister()
    let @" = s:restore_reg
    return ''
endfunction

 autocmd BufReadPre * if getfsize(expand("%")) > 10000000 | setlocal noundofile nofoldenable syntax=OFF | endif

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

if has('clipboard')
  if has('mac') || !empty($DISPLAY)
    if has('unnamedplus')
      set clipboard=unnamedplus
    else
      set clipboard=unnamed
    endif
  endif
endif

if exists('$SSH_TTY')
  function! Osc52yank()
    " Base64 encode the yanked text
    if len(@0) > 100000
      return
    endif
    let buffer = system('base64 -w 0', @0)
    let buffer = substitute(buffer, '\n', '', 'g')

    " Write to a temp file to avoid shell escaping issues
    let temp_file = tempname()
    call writefile([printf("\033]52;c;%s\033\\", buffer)], temp_file, 'b')
    call system('cat ' . shellescape(temp_file) . ' > /dev/tty')
    call delete(temp_file)
  endfunction

  augroup Yank
    autocmd!
    autocmd TextYankPost * if v:event.operator ==# 'y' | call Osc52yank() | endif
  augroup end
endif

packadd cfilter
]])

-- k("n", "<leader>dt", function()
--   if vim.diagnostic.is_enabled() then
--     vim.diagnostic.enable(false)
--     print("diags: disabled")
--   else
--     vim.diagnostic.enable(true)
--     print("diags: enabled")
--   end
-- end)

--- delete all buffers except current one
-- vim.keymap.set("n", "<leader>d", function()
--   local cur = vim.api.nvim_get_current_buf()
--
--   for _, buf in ipairs(vim.api.nvim_list_bufs()) do
--     if buf ~= cur and vim.api.nvim_buf_is_loaded(buf) then
--       pcall(vim.api.nvim_buf_delete, buf, { force = true })
--     end
--   end
-- end, { desc = "Delete all other buffers" })

vim.api.nvim_set_keymap("i", "<C-j>", "pumvisible() ? '<C-n>' : '<C-j>'", { expr = true, noremap = true })
vim.api.nvim_set_keymap("i", "<C-k>", "pumvisible() ? '<C-p>' : '<C-k>'", { expr = true, noremap = true })

vim.keymap.set("n", "<C-1>", "1gt", opt)
vim.keymap.set("n", "<C-2>", "2gt", opt)
vim.keymap.set("n", "<C-3>", "3gt", opt)
vim.keymap.set("n", "<C-4>", "4gt", opt)
vim.keymap.set("n", "<C-5>", "5gt", opt)
vim.keymap.set("n", "<C-6>", "6gt", opt)
vim.keymap.set("n", "<C-7>", "7gt", opt)
vim.keymap.set("n", "<C-8>", "8gt", opt)
vim.keymap.set("n", "<C-9>", "9gt", opt)

--- macros
k("x", "Q", "<cmd>norm @q<CR>", opt)

--- keep cursor in same position when yanking in visual
k("x", "y", [[ygv<Esc>]], silent)

-- notes
k("n", "<leader>n", "<cmd>e ~/notes.md<cr>", silent)

--- visual selection search ---
k("v", "<enter>", [[y/\V<C-r>=escape(@",'/\')<CR><CR>]], silent)

--- copy diagnostic
vim.keymap.set("n", "<leader>e", function()
  vim.diagnostic.open_float(nil, { focus = true })
end)

--- copy block
k("n", "cp", "yap<S-}>p", opt)

k("n", "<D-i>", "<c-i>", opt)
k("n", "<D-o>", "<c-o>", opt)

k("n", "<leader>cd", function()
  vim.cmd.lcd("%:p:h")
  print("new lcd: " .. vim.fn.getcwd())
end, { silent = true })

-- Copy full file path
k("n", "<leader>cp", '<cmd>let @+ = expand("%:p")<CR>', opt)

--- when using J keep cursor to the right
k({ "n", "v" }, "J", "mzJ`z")

-- make dot work in visual mode
k("v", ".", "<cmd>norm .<cr>", opt)

--- go ---
k("n", "gt", ":GoTagAdd<cr>", silent)

--- file ---
-- k("n", "<leader>da", "<cmd>%bd|e#<cr>", silent)

k("n", "gy", "`[v`]", { desc = "Select recently pasted, yanked or changed text" })

k("x", ",a", "<cmd>!column -t<cr>")

--- terminal ---
k("t", "<M-BS>", "\x17", { noremap = true })
k("t", "<C-BS>", "\x17", { noremap = true })
-- k("i", "<C-BS>", "\x17", { noremap = true })

-- k("i", nv("BS"), "\x17", { noremap = true })
k("c", "<C-BS>", "\x17", { noremap = true })

-- pass <c-b> to through term for tmux
k("t", "<M-b>", "<C-b>", { noremap = true })

-- switch to normal mode
k("t", "kk", [[<c-\><c-n>]], silent)
k("t", "<c-t>", [[<c-\><c-n><cmd>T<CR>]], silent)

k("t", "<D-e>", [[<c-e>]], silent)
k("t", "<D-d>", [[<c-d>]], silent)
k("t", "<D-c>", [[<c-c>]], silent)
k("t", "<D-p>", [[<c-p>]], silent)
k("t", "<D-n>", [[<c-n>]], silent)
k("t", "<D-r>", [[<c-r>]], silent)

k({ "n" }, "<C-t>", [[<c-\><c-n>:T<CR>]], silent)

k("n", "<M-k>", "<cmd>cprev<cr>", opt)
k("n", "<M-j>", "<cmd>cnext<cr>", opt)

-- Toggle maximize the current window while remembering its size.
local function toggle_maximize()
  local win = vim.api.nvim_get_current_win()

  -- See if this window has saved size
  local ok, saved = pcall(vim.api.nvim_win_get_var, win, "saved_size")

  if ok then
    -- --- Restore ---
    vim.api.nvim_win_set_height(win, saved.height)
    vim.api.nvim_win_set_width(win, saved.width)
    pcall(vim.api.nvim_win_del_var, win, "saved_size")
  else
    -- --- Save current and maximize ---
    local height = vim.api.nvim_win_get_height(win)
    local width = vim.api.nvim_win_get_width(win)

    vim.api.nvim_win_set_var(win, "saved_size", {
      height = height,
      width = width,
    })

    vim.cmd("wincmd _") -- maximize height
    vim.cmd("wincmd |") -- maximize width
  end
end

vim.keymap.set({ "n", "t" }, "<C-y>", toggle_maximize, { silent = true })

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
  local line_count = vim.api.nvim_buf_line_count(0)
  if line_count < 1000 then
    local save_cursor = vim.fn.getcurpos()
    -- Fixes ^M chars from Windows copy-pastes and removes trailing spaces
    vim.cmd([[keeppatterns %s/\v\s*\r+$|\s+$//e]])
    vim.cmd([[:write ++p]])
    vim.fn.setpos(".", save_cursor)
    -- this is now handled by conform.nvim
  else
    print("buffer over 1000 lines skipping clean up")
  end
end

-- k("i", "<M-BS>", "<C-u>", { noremap = true })
vim.api.nvim_create_user_command("CleanAndSave", clean_space_save, {})

k("n", ",w", function()
  if not check_buf(0) then
    print("save me first!")
    return
  end
  vim.cmd([[:write ++p]])
end, silent)

k("n", "<leader>w", function()
  if not check_buf(0) then
    print("save me first!")
    return
  end
  vim.cmd([[:write ++p]])
end, silent)

-- Toggle quickfix list
k("n", "<M-t>", function()
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
end, silent)

local pair_map = {
  ["("] = ")",
  ["["] = "]",
  ["{"] = "}",
  ["<"] = ">",
  ["'"] = "'",
  ['"'] = '"',
  ["`"] = "`",
}

--- used to insert both () if the next char is (
local r_pair_map = {
  [")"] = true,
  ["]"] = true,
  ["}"] = true,
  [">"] = true,
  [" "] = true,
  ['"'] = true,
  ["'"] = true,
  ["`"] = true,
}

local all_pair_map = {}

for _, v in ipairs(pair_map) do
  table.insert(all_pair_map, v)
end

for _, v in ipairs(r_pair_map) do
  table.insert(all_pair_map, v)
end

--- does not use expression mapping that can cause latency overhead
k("i", "<BS>", function()
  local _, col = unpack(vim.api.nvim_win_get_cursor(0))
  if col == 0 then
    return vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<BS>", true, false, true), "n", false)
  end

  local line = vim.fn.getline(".")
  if col > #line then
    return vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<BS>", true, false, true), "n", false)
  end

  local prev_char = line:sub(col, col)
  local next_char = line:sub(col + 1, col + 1)

  local keys = pair_map[prev_char] == next_char and "<Del><C-h>" or "<BS>"
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), "n", false)
end)
