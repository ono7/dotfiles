local opt = { noremap = true }
local silent = { noremap = true, silent = true }

local k = vim.keymap.set

local function trim_path(s)
  if #s < 50 then
    return s
  else
    local l = #s / 2
    return s:sub(-l)
  end
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "noice", "markdown", "git", "conform-info", "snippets" },
  callback = function(event)
    vim.keymap.set("n", "<C-/>", "<cmd>close<CR>", {
      buffer = event.buf,
      silent = true,
      desc = "Close Noice history window",
    })
  end,
})

--- nop ---
-- k({ "n", "i", "v", "t" }, "<D-q>", "")
k("n", "ZZ", "")
k("n", "ZQ", "")
-- k("i", "<M-e>", "")
k("i", "<M-C-U>", "")
-- k("n", "<M-e>", "")

k("n", "<space>", "")
vim.g.mapleader = " "

-- prevents matchit from mapping [%
vim.g.loaded_matchit = 1

vim.cmd([[

command! Mktags call system('ctags -R .')
command! D bd!
"command! Da %bd!

cnoreabbrev qq qa!

map Q <Nop>

" Kill forward to end of line (C-k)
cnoremap <expr> <C-k> repeat("\<Del>", strlen(getcmdline()) - getcmdpos() + 1)

" Kill backward to start of line (C-u)
cnoremap <expr> <C-u> repeat("\<BS>", getcmdpos() - 1)

inoremap <C-BS> <C-g>u<C-w>
inoremap <M-BS> <C-g>u<C-w>

" dont overwrite the register after pasting in visual mode
xnoremap p P

" move to beginning of doc/end of doc
inoremap <M-lt> <C-g>u<C-o>gg<C-o>^
inoremap <M->> <C-g>u<C-o>G<C-o>$

" Emacs-style Paragraph Navigation (Insert Mode)
inoremap <M-a> <C-o>{
inoremap <M-e> <C-o>}

" undo in insert mode
inoremap <C-/> <C-u>

function! DuplicateAndMark()
    let l:c = col('.')
    " Duplicate line above using the unnamed register
    execute "normal! yyP"
    " Restore cursor column on the new line
    call cursor(line('.'), l:c)
    " Move down to the original line (mimicking your previous <Down>)
    execute "normal! j"

    redraw
    echo "Mark set"
endfunction

inoremap <silent> <C-,> <C-o>:call DuplicateAndMark()<CR>
nnoremap <silent> <C-,> <cmd>call DuplicateAndMark()<CR>

" we lose the ability to do C-r in insert...
" but gain navigational speed
inoremap <C-r> <C-o>?
inoremap <C-s> <C-o>/
nnoremap <C-r> ?
nnoremap <C-s> /

cabbrev <expr> w!! (getcmdtype() == ':' && getcmdline() == 'w!!') ? 'w !sudo tee > /dev/null %' : 'w!!'

augroup CleanNoName
  autocmd!
  " Mark unnamed, non-special buffers to wipe ONLY if completely empty and unmodified
  autocmd BufLeave * if bufname('') ==# '' && &buftype ==# '' && !&modified && line('$') == 1 && getline(1) ==# ''
        \ | setlocal bufhidden=wipe
        \ | endif
augroup END

" --- Emacs Navigation Parity ---

" Character motions
inoremap <C-p> <Up>
inoremap <C-n> <Down>

" === PARAGRAPH MOVEMENT ===
inoremap <M-{> <C-o>{
inoremap <M-}> <C-o>}

" === DELETION ===
" ^d = Delete Forward
inoremap <C-d> <C-g>u<Del>

" ^h = Delete Backward (Standard Backspace)
inoremap <C-h> <C-g>u<BS>

" ~d = Delete Word Forward
inoremap <M-d> <C-g>u<C-o>dw

" Kill to end of line (store in register)
inoremap <C-k> <C-g>u<C-o>D

" Kill to the beginning of the line
inoremap <C-u> <C-g>u<C-o>d0<C-o>x

" Paste the contents of register 'k' (like Emacs yank)
inoremap <C-y> <C-r>"

" ~k = Kill to end of paragraph (Rough approximation)
inoremap <M-k> <C-g>u<C-o>d}

" === CASE TRANSFORMATION PARITY ===
inoremap <M-u> <Esc>gUiwea
inoremap <M-l> <Esc>guiwea

" usefull when only visual block selection needs to be replaced
xnoremap & :<C-u>'<,'>s/\%V\v

" Move visual selection down
vnoremap J :m '>+1<CR>gv=gv

" Move visual selection up
vnoremap K :m '<-2<CR>gv=gv

nnoremap vw viw
nnoremap vp vip
nnoremap vW viW
nnoremap dW diW

nnoremap <C-w>q <C-w>c
nnoremap <C-w><C-q> <C-w>c
vnoremap <C-w>q <C-w>c

nnoremap <m-t> <cmd>tabnew<cr>
nnoremap <m-]> <cmd>tabnext<cr>
nnoremap <m-[> <cmd>tabprev<cr>

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

inoremap <M-S-o> <C-o>O
inoremap <M-o> <C-o>o
inoremap <C-w> <Esc>:w<CR>a

nnoremap <C-d> x
nnoremap <M-d> dw

" Function to set the mark and print message
function! SetGlobalMark(char)
  execute 'normal! m' . a:char
  echo "Mark set"
endfunction

" Map lowercase 'm' to call the function with the Uppercase target
nnoremap <silent> ma :call SetGlobalMark('A')<CR>
nnoremap <silent> mb :call SetGlobalMark('B')<CR>
nnoremap <silent> mr :call SetGlobalMark('R')<CR>
nnoremap <silent> ms :call SetGlobalMark('S')<CR>
nnoremap <silent> mt :call SetGlobalMark('T')<CR>

" Jump mappings (unchanged, direct mapping)
nnoremap 'a `A
nnoremap 'b `B
nnoremap 'r `R
nnoremap 's `S
nnoremap 't `T

nnoremap D d$
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'
nnoremap <silent> <space><space> <cmd>noh<cr>
nnoremap <space>a ggVG
nnoremap U <c-r>

nnoremap ; :
xnoremap ; <Esc>:

vnoremap > >gv
vnoremap < <gv

" fix dot operator in visual select
xnoremap . :<C-u>normal! .<CR>

nnoremap Y yg_

nnoremap j gj
nnoremap k gk

" includes filename in commit, but better to use git log --name-only
nnoremap gm :Git add % <bar> Git commit % -m "<C-r>=expand('%:t')<CR>, "<Left>

nnoremap <leader>td <cmd>e ~/todo.md<CR>

xnoremap H <gv
xnoremap L >gv
xnoremap y ygv<Esc>

function! SmartClose() abort
  let l:current_buf = bufnr('%')

  bprevious

  if bufnr('%') == l:current_buf
    enew
  endif

  if bufexists(l:current_buf)
    execute 'silent! bdelete ' . l:current_buf
  endif
endfunction

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
vnoremap " :<C-u>call WrapSelection('"', '"')<CR>
xnoremap ` :<C-u>call WrapSelection('`', '`')<CR>
xnoremap ( :<C-u>call WrapSelection('(', ')')<CR>
xnoremap [ :<C-u>call WrapSelection('[', ']')<CR>

set ttyfast
set confirm
set nolisp

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

function! s:CleanAndSave()
  let l:save = winsaveview()

  " Remove trailing whitespace and Windows ^M characters
  keeppatterns %s/\v\s*\r+$\vert{}\s+$//e

  " Remove empty lines at the end of the file
  keeppatterns %s#\($\n\s*\)\+\%$##e

  " Convert tabs to spaces (if expandtab is set)
  if &expandtab
    retab!
  endif

  call winrestview(l:save)
endfunction

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

packadd cfilter
]])

if vim.env.SSH_TTY then
  vim.g.clipboard = {
    name = "OSC 52",
    copy = {
      ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
      ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
    },
    paste = {
      ["+"] = require("vim.ui.clipboard.osc52").paste("+"),
      ["*"] = require("vim.ui.clipboard.osc52").paste("*"),
    },
  }
end

-- fix rsi issues with insert mode
local imap = function(lhs, rhs, desc)
  vim.keymap.set("i", lhs, rhs, { noremap = true, silent = true, nowait = true, desc = desc })
end

-- Line navigation
imap("<C-a>", "<C-o>_", "Move to beginning of line")
imap("<C-e>", "<End>", "Move to end of line")

-- Character / Word navigation
imap("<C-b>", "<Left>", "Move backward one character")
imap("<C-f>", "<Right>", "Move forward one character")
imap("<C-p>", "<Up>", "Move up one character")
imap("<C-n>", "<Down>", "Move down one character")
imap("<M-b>", "<C-Left>", "Move backward one word")
imap("<M-f>", "<C-Right>", "Move forward one word")

-- Deletion
imap("<C-d>", "<Del>", "Delete forward character")
imap("<C-k>", "<C-o>D", "Kill line forward")
imap("<C-u>", "<C-u>", "Kill line backward")
imap("<M-d>", "<C-o>dw", "Delete word forward")

local cmap = function(lhs, rhs, desc)
  vim.keymap.set("c", lhs, rhs, { noremap = true, desc = desc })
end

-- Line navigation
cmap("<C-a>", "<Home>", "Start of line")
cmap("<C-e>", "<End>", "End of line")

-- Character navigation (home-row)
cmap("<C-b>", "<Left>", "Cursor left")
vim.keymap.set("c", "<C-f>", function()
  if vim.fn.getcmdpos() > #vim.fn.getcmdline() then
    return vim.o.cedit
  end
  return "<Right>"
end, { expr = true, desc = "Cursor right, or open command-line window at EOL" })

-- Word navigation
cmap("<M-b>", "<S-Left>", "Word backward")
cmap("<M-f>", "<S-Right>", "Word forward")

-- Deletion
cmap("<C-d>", "<Del>", "Delete character forward")
cmap("<M-d>", "<S-Right><C-w>", "Delete word forward")

-- Kill line forward (cursor to end)
vim.keymap.set("c", "<C-k>", function()
  local pos = vim.fn.getcmdpos()
  local line = vim.fn.getcmdline()
  vim.fn.setcmdline(string.sub(line, 1, pos - 1))
  return ""
end, { expr = true, desc = "Kill to end of line" })

k({ "x", "n" }, "<leader>p", '"+p', opt)

--- macros
k("x", "Q", "<cmd>norm @q<CR>", opt)

--- keep cursor in same position when yanking in visual
k("x", "y", [[ygv<Esc>]], silent)

-- notes
k("n", "<leader>n", "<cmd>e ~/notes.md<cr>", silent)

--- visual selection search ---
k("v", "<enter>", [[y/\V<C-r>=escape(@",'/\')<CR><CR>]], silent)

vim.keymap.set("n", "<leader>te", function()
  local dir = vim.fn.expand("%:p:h")
  vim.fn.jobstart({ "alacritty", "--working-directory", dir }, { detach = true })
end, { desc = "Open Alacritty in current directory" })

-- show diagnostics for the current buffer on quickfixlist
k("n", "<leader>q", function()
  vim.diagnostic.setqflist({ bufnr = 0 })
end, { desc = "Buffer LSP to Quickfix" })

vim.keymap.set("n", "<leader>nq", function()
  -- Get cursor position (0-indexed for API)
  local lnum = vim.api.nvim_win_get_cursor(0)[1] - 1

  -- Fetch diagnostics for the current line
  local diagnostics = vim.diagnostic.get(0, { lnum = lnum })
  if #diagnostics == 0 then
    vim.notify("No diagnostics found on current line", vim.log.levels.WARN)
    return
  end

  -- Extract the rule ID (code) from the first diagnostic
  local rule_id = diagnostics[1].code
  if not rule_id then
    vim.notify("Diagnostic does not contain a rule ID", vim.log.levels.WARN)
    return
  end

  -- Get current line text
  local line = vim.api.nvim_get_current_line()

  -- Append logic: check if `# noqa` already exists to append vs create
  local new_line
  if line:match("# noqa:") then
    new_line = line .. " " .. rule_id
  elseif line:match("# noqa") then
    new_line = line:gsub("# noqa", "# noqa: " .. rule_id)
  else
    new_line = line .. " # noqa: " .. tostring(rule_id)
  end

  -- Set the updated line
  vim.api.nvim_set_current_line(new_line)

  -- Optional: trigger formatter or clear diagnostics temporarily
  vim.notify("Appended noqa for: " .. tostring(rule_id), vim.log.levels.INFO)
end, { desc = "Automate Ansible noqa appending" })

--- copy diagnostic
vim.keymap.set("n", "<leader>e", function()
  vim.diagnostic.open_float(nil, { focus = true })
end)

--- copy block
k("n", "cp", "yap<S-}>p", opt)

k("n", "<D-i>", "<c-i>", opt)
k("n", "<D-o>", "<c-o>", opt)

k("n", "<M-c>", function()
  vim.cmd.lcd("%:p:h")
  local path = vim.fn.getcwd()
  print("new lcd: " .. trim_path(path))
end, { silent = true })

-- Copy full file path
k("n", "<leader>cp", '<cmd>let @+ = expand("%:p")<CR>', opt)

--- go ---
k("n", "gt", ":GoTagAdd<cr>", silent)

k("n", "gy", "`[v`]", { desc = "Select recently pasted, yanked or changed text" })

--- terminal ---
k("c", "<C-BS>", "\x17", { noremap = true })

-- switch to normal mode
k("t", "<c-x>", [[<c-\><c-n>]], silent)
k("t", "<c-t>", [[<c-\><c-n><cmd>T<CR>]], silent)

-- just send this key so that zsh can use it as move back 1 char (passthrough)
vim.keymap.set("t", "<C-h>", "<C-h>")
vim.keymap.set("t", "<C-p>", "<C-p>")

k("t", "<D-e>", [[<c-e>]], silent)
k("t", "<D-d>", [[<c-d>]], silent)
k("t", "<D-c>", [[<c-c>]], silent)
k("t", "<D-n>", [[<c-n>]], silent)
k("t", "<D-r>", [[<c-r>]], silent)

k({ "n" }, "<C-t>", [[<c-\><c-n>:T<CR>]], silent)

k("n", "<M-k>", "<cmd>cprev<cr>", opt)
k("n", "<M-j>", "<cmd>cnext<cr>", opt)

local function toggle_maximize()
  local win = vim.api.nvim_get_current_win()
  local ok, saved = pcall(vim.api.nvim_win_get_var, win, "saved_size")

  if ok then
    -- --- Restore ---
    vim.api.nvim_win_set_height(win, saved.height)
    vim.api.nvim_win_set_width(win, saved.width)

    -- Restore original constraints
    vim.o.winminheight = saved.minheight
    vim.o.winminwidth = saved.minwidth

    pcall(vim.api.nvim_win_del_var, win, "saved_size")
    -- Reset all windows to a balanced state
    vim.cmd("wincmd =")
  else
    -- --- Save and Maximize ---
    local height = vim.api.nvim_win_get_height(win)
    local width = vim.api.nvim_win_get_width(win)

    -- Save current sizes and current constraints
    vim.api.nvim_win_set_var(win, "saved_size", {
      height = height,
      width = width,
      minheight = vim.o.winminheight,
      minwidth = vim.o.winminwidth,
    })

    -- Remove constraints so the window can fill the space
    vim.o.winminheight = 0
    vim.o.winminwidth = 0

    vim.cmd("wincmd _") -- Maximize height
    vim.cmd("wincmd |") -- Maximize width
  end
end

vim.keymap.set({ "n", "t" }, "<M-y>", toggle_maximize, { silent = true })

-- save and clean up file
vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("CleanOnWrite", { clear = true }),
  callback = function(args)
    -- Short-circuit immediately on massive files
    if vim.b[args.buf].large_file then
      return
    end

    local save = vim.fn.winsaveview()

    -- Remove trailing whitespace, trailing tabs, and Windows ^M characters
    vim.cmd([[keeppatterns %s/\v\s*\r+$\vert{}\s+$//e]])

    -- Remove empty lines at the end of the file
    vim.cmd([[keeppatterns %s#\($\n\s*\)\+\%$##e]])

    -- Convert remaining tabs to spaces
    if vim.bo[args.buf].expandtab then
      vim.cmd([[retab!]])
    end

    vim.fn.winrestview(save)
  end,
})

-- 1. Safety check to prevent E32 on unnamed buffers
local function check_buf(bufnr)
  local bufname = vim.api.nvim_buf_get_name(bufnr)
  if bufname == "" then
    return false
  end
  return true
end

-- 2. Map <leader>w to a raw write.
vim.keymap.set("n", "<leader>w", function()
  if not check_buf(0) then
    vim.notify("Save first..", vim.log.levels.WARN)
    return
  end
  vim.cmd([[:write ++p]])
end, { silent = true, desc = "Write file (creates parent dirs)" })

vim.keymap.set("n", "<M-w>", function()
  if not check_buf(0) then
    vim.notify("Save first..", vim.log.levels.WARN)
    return
  end
  vim.cmd([[:write ++p]])
end, { silent = true, desc = "Write file (creates parent dirs)" })

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

-- --- Custom Auto-Pair Engine ---

local my_pair_map = {
  ["("] = ")",
  ["["] = "]",
  ["{"] = "}",
  ["<"] = ">",
  ["'"] = "'",
  ['"'] = '"',
  ["`"] = "`",
}

-- NOTE(jlima): Permitted right-hand characters that allow bracket pair expansion.
local r_bracket_map = {
  [")"] = true,
  ["]"] = true,
  ["}"] = true,
  [">"] = true,
  [" "] = true,
  ["\t"] = true,
}

-- NOTE(jlima): Strict whitespace-only guard for quotes to prevent spurious pairs inside existing syntax.
local r_quote_ws_map = {
  [""] = true,
  [" "] = true,
  ["\t"] = true,
}

-- NOTE(jlima): Permitted left-hand characters that allow quote pair expansion.
local l_quote_prefix_map = {
  [""] = true,
  [" "] = true,
  ["\t"] = true,
  ["("] = true,
  ["["] = true,
  ["{"] = true,
  ["<"] = true,
  ["="] = true,
  [":"] = true,
  [","] = true,
}

-- NOTE(jlima): Reads an exact 2-byte buffer window around the cursor via one call to avoid allocating entire minified lines.
local function get_adjacent_chars()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local row, col = cursor[1] - 1, cursor[2]

  local start_col = col > 0 and (col - 1) or 0
  local text = vim.api.nvim_buf_get_text(0, row, start_col, row, col + 1, {})[1] or ""

  local prev_char = ""
  local next_char = ""

  if col == 0 then
    next_char = text:sub(1, 1)
  else
    prev_char = text:sub(1, 1)
    next_char = text:sub(2, 2)
  end

  return prev_char, next_char, col
end

vim.keymap.set("i", "<BS>", function()
  local prev_char, next_char, col = get_adjacent_chars()
  if col == 0 then
    return "<BS>"
  end

  if my_pair_map[prev_char] and my_pair_map[prev_char] == next_char then
    return "<BS><Del>"
  end

  return "<BS>"
end, { expr = true, replace_keycodes = true, noremap = true })

vim.keymap.set("i", "<C-S-e>", "<Esc>Go", { noremap = true, silent = true, desc = "Jump to end of file and insert new line" })

local function handle_close(char)
  local _, next_char = get_adjacent_chars()
  if next_char == char then
    return "<Right>"
  end
  return char
end

local function handle_open(char, close_char)
  local prev_char, next_char = get_adjacent_chars()

  if char == "{" and prev_char == "{" and next_char == "}" then
    return "{  }<C-g>U<Left><Left>"
  end

  local is_allowed = (next_char == "") or r_bracket_map[next_char]

  -- NOTE(jlima): Strict exception to support Ansible Jinja "{{  }}".
  -- ONLY "{" is permitted to auto-close inside quotes.
  if char == "{" and (next_char == '"' or next_char == "'") then
    is_allowed = true
  end

  if not is_allowed then
    return char
  end

  return char .. close_char .. "<C-g>U<Left>"
end

local function handle_quote(char)
  local prev_char, next_char = get_adjacent_chars()

  -- Overtype: step over if cursor is immediately before matching quote
  if next_char == char then
    return "<Right>"
  end

  -- NOTE(jlima): Reject quote expansion when preceded by alphanumeric characters (e.g. contractions).
  if not l_quote_prefix_map[prev_char] then
    return char
  end

  -- NOTE(jlima): Restrict quote auto-pairing strictly to EOL or whitespace.
  if not r_quote_ws_map[next_char] then
    return char
  end

  return char .. char .. "<C-g>U<Left>"
end

vim.keymap.set("i", "{", function()
  return handle_open("{", "}")
end, { expr = true, noremap = true })

vim.keymap.set("i", "(", function()
  return handle_open("(", ")")
end, { expr = true, noremap = true })

vim.keymap.set("i", "[", function()
  return handle_open("[", "]")
end, { expr = true, noremap = true })

vim.keymap.set("i", "}", function()
  return handle_close("}")
end, { expr = true, noremap = true })

vim.keymap.set("i", ")", function()
  return handle_close(")")
end, { expr = true, noremap = true })

vim.keymap.set("i", "]", function()
  return handle_close("]")
end, { expr = true, noremap = true })

vim.keymap.set("i", '"', function()
  return handle_quote('"')
end, { expr = true, noremap = true })

vim.keymap.set("i", "'", function()
  return handle_quote("'")
end, { expr = true, noremap = true })

vim.keymap.set("i", "`", function()
  return handle_quote("`")
end, { expr = true, noremap = true })

vim.keymap.set("i", "<CR>", function()
  local prev_char, next_char, col = get_adjacent_chars()
  if col == 0 or next_char == "" then
    return "<CR>"
  end

  local pair = prev_char .. next_char
  if pair == "{}" or pair == "()" or pair == "[]" then
    return "<CR><Esc>O"
  end

  return "<CR>"
end, { expr = true, noremap = true })

-- window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Focus left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Focus lower window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Focus upper window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Focus right window" })
