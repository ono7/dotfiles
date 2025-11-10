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
cnoremap <c-h> <Left>
cnoremap <c-l> <Right>

" inoremap <C-a> <Home>
" Make Ctrl-Backspace delete the entire word including special chars

inoremap <C-BS> <C-w>
inoremap <C-h> <C-w>
inoremap <C-a> <C-o>^
inoremap <C-e> <End>

nnoremap ; :
xnoremap ; :
nnoremap D d$
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'
nnoremap <silent> ,d <cmd>bd!<cr>
nnoremap <silent> <space><space> <cmd>noh<cr>
nnoremap <space>a ggVG
nnoremap U <c-r>
nnoremap v <c-v>
nnoremap Y yg_

nnoremap <expr> j v:count ? (v:count > 1 ? "m'" . v:count : '') . 'j' : 'gj'
nnoremap <expr> k v:count ? (v:count > 1 ? "m'" . v:count : '') . 'k' : 'gk'

nnoremap <esc>k <cmd>cprev<cr>
nnoremap <esc>j <cmd>cnext<cr>
nnoremap gm :Git add % <bar> Git commit % -m ""<Left>

nnoremap <leader>d <cmd>%bdelete\|edit#\|bdelete#<CR>
nnoremap <leader>x <cmd>x<CR>
nnoremap <leader>td <cmd>e ~/todo.md<CR>

xnoremap H <gv
xnoremap L >gv
xnoremap y ygv<Esc>

" xnoremap ' <esc>`>a'<esc>`<i'<esc>f'a
" xnoremap " <esc>`>a"<esc>`<i"<esc>f"a
" xnoremap ` <esc>`>a`<esc>`<i`<esc>f`a
" xnoremap ( <esc>`>a)<esc>`<i(<esc>
" xnoremap [ <esc>`>a]<esc>`<i[<esc>
" xnoremap { <esc>`>a}<esc>`<i{<esc>
" xnoremap < <esc>`>a><esc>`<i<<esc>

function! WrapSelection(left, right)
    let save_reg = @"
    normal! `
    call search('\S', 'c')
    let start_pos = getpos('.')
    normal! `>
    let end_pos = getpos('.')

    call setpos('.', end_pos)
    execute "normal! a" . a:right . "\<esc>"
    call setpos('.', start_pos)
    execute "normal! i" . a:left . "\<esc>"
    let @" = save_reg
endfunction

xnoremap ' :<C-u>call WrapSelection("'", "'")<CR>
xnoremap " :<C-u>call WrapSelection('"', '"')<CR>
xnoremap ` :<C-u>call WrapSelection('`', '`')<CR>
xnoremap ( :<C-u>call WrapSelection('(', ')')<CR>
xnoremap [ :<C-u>call WrapSelection('[', ']')<CR>
xnoremap { :<C-u>call WrapSelection('{', '}')<CR>
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

" autocmd BufReadPre * if getfsize(expand("%")) > 10000000 | setlocal noundofile nofoldenable | endif

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

---
k("n", "<leader>dt", function()
  if vim.diagnostic.is_enabled() then
    vim.diagnostic.enable(false)
    print("diags: disabled")
  else
    vim.diagnostic.enable(true)
    print("diags: enabled")
  end
end)

--- macros
k("x", "Q", "<cmd>norm @q<CR>", opt)

--- keep cursor in same position when yanking in visual
k("x", "y", [[ygv<Esc>]], silent)

-- notes
k("n", "<leader>n", "<cmd>e ~/notes.md<cr>", silent)

--- visual selection search ---
k("v", "<enter>", [[y/\V<C-r>=escape(@",'/\')<CR><CR>]], silent)

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
k("n", "<leader>da", "<cmd>%bd|e#<cr>", silent)

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

-- captures :messages to buffer
k("n", "<Leader>m", function()
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
