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

-- prevents matchit from mapping [%
vim.g.loaded_matchit = 1

vim.cmd([[

command! Mktags call system('ctags -R .')
command! D bd!
command! Da %bd!

cnoreabbrev qq qa!

map Q <Nop>

" this combines best of vim with the best of emacs which is available everywhere..
cnoremap <c-a> <Home>
cnoremap <c-b> <left>
cnoremap <c-e> <end>
nnoremap <c-e> <end>
cnoremap <c-l> <Right>

inoremap <C-BS> <C-w>

" we lose the ability to do C-r in insert...
" but gain navigational speed
inoremap <C-r> <C-o>?\v
inoremap <C-s> <C-o>/\v

" --- Emacs Navigation Parity ---

" Character motions
inoremap <C-p> <Up>
inoremap <C-n> <Down>

inoremap <C-b> <Left>
inoremap <C-f> <Right>

" the alpha and the omega
inoremap <C-a> <C-o>^
inoremap <C-e> <End>

" === WORD MOVEMENT ===
" ~f = moveWordForward (Emacs jumps to end of word)
inoremap <M-f> <C-o>e<Right>
" ~b = moveWordBackward
inoremap <M-b> <C-o>b

" Send Escape+b/f to the shell when Alt-b/f is pressed
" ~f, ~b
tnoremap <M-b> <Esc>b
tnoremap <M-f> <Esc>f

" === PARAGRAPH MOVEMENT ===
" ~{ = Start of para / ~} = End of para
inoremap <M-{> <C-o>{
inoremap <M-}> <C-o>}

" === DELETION ===
" ^d = Delete Forward
inoremap <C-d> <Del>
" ^h = Delete Backward (Standard Backspace)
inoremap <C-h> <BS>

" ~d = Delete Word Forward
inoremap <M-d> <C-o>dw
" ~^h = Delete Word Backward (Option+Ctrl+Backspace)
" Note: Mapped to Option-Backspace (<M-BS>) for convenience
inoremap <M-BS> <C-w>

" Kill to end of line (store in register)
inoremap <C-k> <C-o>D

" ~k = Kill to end of paragraph (Rough approximation)
inoremap <M-k> <C-o>d}

" Yank (paste from default register), using this for completion instead
"inoremap <C-y> <C-r>"

" select last inserted text
inoremap <C-l> <Esc>`[v`]

" === CASE TRANSFORMATION PARITY ===
" Uppercase Word (Emacs M-u)
" Logic: Exit insert -> Uppercase to end of word -> Append
inoremap <M-u> <Esc>gUea

" Lowercase Word (Emacs M-l)
" Logic: Exit insert -> Lowercase to end of word -> Append
inoremap <M-l> <Esc>guea

" usefull when only visual block selection needs to be replaced
xnoremap & :<C-u>'<,'>s/\%V\v

" Move visual selection down
vnoremap J :m '>+1<CR>gv=gv

" Move visual selection up
vnoremap K :m '<-2<CR>gv=gv

nnoremap vw viw
nnoremap vp vip
nnoremap cw ciw
nnoremap dw diw
nnoremap vW viW
nnoremap cW ciW
nnoremap dW diW
nnoremap <c-s> :Rg<space>

" Set mark in insert mode
function! InsertSetMark() abort
  normal! mz
  echom "mark set"
endfunction

" Swap cursor with mark in insert mode
function! InsertSwapMark() abort
  let mark_pos = getpos("'z")

  if mark_pos[1] == 0
    return
  endif

  let cur_pos = getpos('.')

  " Jump to mark
  call setpos('.', mark_pos)

  " Update mark to old cursor position
  call setpos("'z", cur_pos)
endfunction

" Keymaps
inoremap <c-space> <C-o>:call InsertSetMark()<CR>
"inoremap <C-x> <C-o>:call InsertSwapMark()<CR>
nnoremap D d$
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'
nnoremap <silent> <space><space> <cmd>noh<cr>
nnoremap <space>a ggVG
nnoremap U <c-r>

" TODO: syntaxcomplete#Complete need to implement this for omnifunc
" nnoremap v <c-v>

vnoremap > >gv
vnoremap < <gv

" fix dot operator in visual select
xnoremap . :<C-u>normal! .<CR>

nnoremap Y yg_

nnoremap j gj
nnoremap k gk

" xnoremap p P
xnoremap p "_dP

" clear hlsearch on esc
" nnoremap <silent> <Esc> :noh<CR><Esc>

" includes filename in commit, but better to use git log --name-only
 nnoremap gm :Git add % <bar> Git commit % -m "<C-r>=expand('%:t')<CR>: "<Left>

"nnoremap <leader>d <cmd>%bd!\|e#\|bd!#<CR>
" close: closes a window not a buffer, leaving splits working as intended
" this has a conflict with diagnostics
" nnoremap <leader>d <cmd>close!<CR>

nnoremap <leader>x <cmd>x<CR>
nnoremap <leader>td <cmd>e ~/todo.md<CR>

xnoremap H <gv
xnoremap L >gv
xnoremap y ygv<Esc>

function! SmartClose()
  let l:current_buf = bufnr("%")
  " Try to go to the previous buffer
  bprevious
  " If we didn't move (meaning there was only 1 buffer), open a blank one
  if bufnr("%") == l:current_buf
    enew
  endif
  " Delete the original buffer
  " Use bdelete! to force close even if unsaved (optional, remove ! for safety)
  execute "bdelete " . l:current_buf
endfunction
nnoremap <silent> <leader>d :call SmartClose()<CR>

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
" this overrides the " register key
" xnoremap " :<C-u>call WrapSelection('"', '"')<CR>
xnoremap ` :<C-u>call WrapSelection('`', '`')<CR>
xnoremap ( :<C-u>call WrapSelection('(', ')')<CR>
xnoremap [ :<C-u>call WrapSelection('[', ']')<CR>
" xnoremap { :<C-u>call WrapSelection('{', '}')<CR>
" xnoremap < :<C-u>call WrapSelection('<', '>')<CR>

" inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"

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

-- vim.keymap.set("n", "<leader>d", function()
--   local current_buf = vim.api.nvim_get_current_buf()
--   -- Try to switch to the alternate buffer (the last one you were editing)
--   local alternate_buf = vim.fn.bufnr("#")
--   if vim.api.nvim_buf_is_loaded(alternate_buf) and alternate_buf ~= current_buf then
--     vim.api.nvim_set_current_buf(alternate_buf)
--   else
--     -- Fallback: Cycle to previous buffer
--     vim.cmd("bprevious")
--   end
--   -- If we haven't moved (meaning this was the only buffer), open a new scratch buffer
--   if vim.api.nvim_get_current_buf() == current_buf then
--     vim.cmd("enew")
--   end
--   -- Finally, delete the original buffer
--   vim.cmd("bdelete " .. current_buf)
-- end, { desc = "Close buffer, keep window" })

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

-- vim.api.nvim_set_keymap("i", "<C-j>", "pumvisible() ? '<C-n>' : '<C-j>'", { expr = true, noremap = true })
-- vim.api.nvim_set_keymap("i", "<C-k>", "pumvisible() ? '<C-p>' : '<C-k>'", { expr = true, noremap = true })

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

-- --- when using J keep cursor to the right
-- k({ "n", "v" }, "J", "mzJ`z")

--- go ---
k("n", "gt", ":GoTagAdd<cr>", silent)

--- file ---
-- k("n", "<leader>da", "<cmd>%bd|e#<cr>", silent)

k("n", "gy", "`[v`]", { desc = "Select recently pasted, yanked or changed text" })

-- k("x", ",a", "<cmd>!column -t<cr>")

--- terminal ---
k("t", "<M-BS>", "\x17", { noremap = true })
k("t", "<C-BS>", "\x17", { noremap = true })
-- k("i", "<C-BS>", "\x17", { noremap = true })

-- k("i", nv("BS"), "\x17", { noremap = true })
k("c", "<C-BS>", "\x17", { noremap = true })

-- pass <c-b> to through term for tmux
-- k("t", "<M-b>", "<C-b>", { noremap = true })

-- switch to normal mode
k("t", "<c-x>", [[<c-\><c-n>]], silent)
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

-- k("n", ",w", function()
--   if not check_buf(0) then
--     print("save me first!")
--     return
--   end
--   vim.cmd([[:write ++p]])
-- end, silent)

k("n", "<leader>w", function()
  if not check_buf(0) then
    print("save me first!")
    return
  end
  vim.cmd([[:write ++p]])
end, silent)

-- Toggle quickfix list
k("n", "<c-/>", function()
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

-- vim.keymap.set("i", "<CR>", function()
--   local col = vim.fn.col(".")
--   local line = vim.fn.getline(".")
--   local prev = col > 1 and line:sub(col - 1, col - 1) or ""
--
--   if prev == "{" then
--     return "<CR>}<Esc>O"
--   end
--   if prev == "[" then
--     return "<CR>]<Esc>O"
--   end
--   if prev == "(" then
--     return "<CR>)<Esc>O"
--   end
--
--   return "<CR>"
-- end, { expr = true, noremap = true })
vim.keymap.set("i", "<CR>", function()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local col = cursor[2]
  if col == 0 then
    return "<CR>"
  end

  local char = vim.api.nvim_buf_get_text(0, cursor[1] - 1, col - 1, cursor[1] - 1, col, {})[1]

  if char == "{" or char == "[" or char == "(" then
    local close = char == "{" and "}" or char == "[" and "]" or ")"
    return "<CR>" .. close .. "<Esc>O"
  end

  return "<CR>"
end, { expr = true, noremap = true })
