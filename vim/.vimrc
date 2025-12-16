" 🐇 Follow the white Rabbit...

set nocompatible
filetype plugin indent on
syntax on

let mapleader = "\<Space>"

" let g:loaded_matchparen = 1
let g:matchparen_timeout = 20
let g:matchparen_insert_timeout = 20

if has("nvim")
  set shada = "'100,<2000,s200,:1000,/1000,h,f1,r/COMMIT_EDITMSG,r/git-rebase-todo,!"add cfilter
  set inccommand=nosplit
  set pumheight=10 pumblend=0
  augroup UpdateShada
    autocmd!
    autocmd BufRead,BufNewFile * call insert(v:oldfiles, expand('%:p'), 0) | wshada
  augroup end
else
  set viminfo='20,<2000,s200,:1000,/1000,h,f1,r/COMMIT_EDITMSG$
  set ttyfast
  augroup UpdateViminfo
    autocmd!
    autocmd BufRead,BufNewFile * call insert(v:oldfiles, expand('%:p'), 0) | wviminfo
  augroup end
endif

" supported patterns, basically everything, must wrap pattren in single quotes
" :Rg 'jlima|test|type \S+ struct'
" :Rg -t go '^type (?![jJ]ob)\w+' -- only match go file types, -t go -t py can be chained
" *********** FLAGS **********
" -uuu  flag support
" -u (.gitignore)
" -uu (hidden + .gitignore),
" -uuu (Binaries + hidden + .gitignore) DO NOT USE THIS!
" :Rg -uu 'jlima|test|type \S+ struct'
" :Rg -uu \"test\" -> will match "test"
" negative lookaround
" :Rg '^from (?!unittest)\w+ import' -- anything but
" :Rg '^from (?!unittest|ansible|pytest)\w+ import' --anything but
" positive lookaround (behind)
" (?<=user_id: )\d+ -- matches only \d+
" positive lookaround (ahead)

if executable('rg')
  let &grepprg = 'rg --vimgrep --no-heading --smart-case --pcre2'
  let &grepformat = '%f:%l:%c:%m'
else
  let &grepprg = 'grep -nHIRE $* .'
  let &grepformat = '%f:%l:%m'
endif

function! Rg(args) abort
  let l:pattern = substitute(a:args, '|', '\\|', 'g')
  execute "silent! grep!" l:pattern
  copen
  redraw!
endfunction
command! -nargs=+ -complete=file Rg call Rg(<q-args>)

set undolevels=999 undoreload=1000

if !isdirectory($HOME."/.vim-undo")
    call mkdir($HOME."/.vim-undo", "p", 0700)
endif

set undodir=~/.vim-undo
set undofile

set path=.,**,**/.*/**
set sw=2 ts=2
set wildmenu wildmode=longest:full,full wildignorecase
set lazyredraw hidden updatetime=300
set incsearch ignorecase smartcase autoindent cindent smartindent
set nohlsearch
set nonumber norelativenumber nocursorline
set ruler
set listchars=tab:→\ ,space:·,trail:•,extends:>,precedes:\
set magic noshowcmd nowrap
set timeout timeoutlen=300 ttimeout ttimeoutlen=50
set scrolloff=3 sidescrolloff=5 nowrap
set backspace=indent,eol,start
set nobackup nowritebackup noswapfile
set fillchars+=vert:│
set fillchars+=diff:╱
let &showbreak="↪ "
set splitbelow splitright
set fileformats=unix fileformat=unix
set matchtime=0
set guicursor=a:block-blinkwait0-blinkoff400-blinkon250-Cursor/lCursor
set tags=./tags,tags;~
set shortmess=atcIoOsT
set laststatus=1
set encoding=utf-8 fileencoding=utf-8
" set iskeyword+=_,-

set termguicolors
if has('win32') || has('win64')
  set shellslash
  set termguicolors
  set shell=cmd
  set shellcmdflag=/c
  inoremap <C-H> <C-W>
endif

try
  tnoremap <c-x> <C-\><C-n>
endtry

try
  " set diffopt=vertical,filler,context:5,internal,algorithm:histogram,indent-heuristic
  set diffopt=vertical,filler,context:5,internal,algorithm:histogram,indent-heuristic,linematch:60,closeoff
catch
  set diffopt=vertical,filler,context:5
endtry

if exists('+wildoptions')
  try
    set wildoptions=pum
    set pumheight=10
  catch
    set wildmenu
    set wildmode=longest:full,full
  endtry
endif

if has('mac')
  set clipboard=unnamedplus
endif


if exists('+wildoptions')
  try
    set wildoptions=pum
    set pumheight=10
  catch
    set wildmenu
    set wildmode=longest:full,full
  endtry
endif

set wildignore+=**/tmp/**
set wildignore+=**/.git/**
set wildignore+=**/__pycache__/**
set wildignore+=**/.ruff_cache/**
set wildignore+=**/site-packages/**
set wildignore+=**/node_modules/**
set wildignore+=.tags
set wildignore+=tags

set noesckeys

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

inoremap <C-,> <C-o>:let c=col('.') <Bar> execute "normal! yyP" <Bar> call cursor(line('.'), c)<CR><C-o><Down>

function! s:ToggleQuickfix() abort
  " Check if a quickfix window is currently open
  let l:qf_exists = !empty(filter(getwininfo(), 'v:val.quickfix'))

  if l:qf_exists
    cclose
  else
    copen
    " Optional: Execute 'wincmd p' here if you wanted the window to open
    " but keep focus on your code. Since you ASKED for focus in QF,
    " we leave this out. copen focuses by default.
  endif
endfunction

" Map Ctrl-\ to toggle logic
nnoremap <silent> <C-\> <cmd>call <SID>ToggleQuickfix()<CR>
inoremap <silent> <C-\> <cmd>call <SID>ToggleQuickfix()<CR>
" Terminal mode handling to exit terminal insert mode first
tnoremap <silent> <C-\> <C-\><C-n><cmd>call <SID>ToggleQuickfix()<CR>

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

" Fix Meta/Alt key detection for non-Neovim
"if !has('nvim')
"    execute "set <M-f>=\ef"
"    execute "set <M-b>=\eb"
"
"   inoremap <M-d> <C-o>dw
"   " ~^h = Delete Word Backward (Option+Ctrl+Backspace)
"   " Note: Mapped to Option-Backspace (<M-BS>) for convenience
"   inoremap <M-BS> <C-w>
"endif

" === WORD MOVEMENT ===
" ~f = moveWordForward (Emacs jumps to end of word)
inoremap f <C-o>e<Right>
" ~b = moveWordBackward
inoremap b <C-o>b

" Send Escape+b/f to the shell when Alt-b/f is pressed
" ~f, ~b
tnoremap b <Esc>b
tnoremap f <Esc>f

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
inoremap d <C-o>dw
" ~^h = Delete Word Backward (Option+Ctrl+Backspace)
" Note: Mapped to Option-Backspace (<M-BS>) for convenience
inoremap <M-BS> <C-w>

" Kill to end of line (store in register)
inoremap <C-k> <C-o>D

" ~k = Kill to end of paragraph (Rough approximation)
inoremap k <C-o>d}

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
inoremap l <Esc>guea

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

nnoremap U <c-r>
nnoremap <c-r> <cmd>browse oldfiles<CR>
nnoremap Y yg_
nnoremap D d$
nnoremap <leader>cd <cmd>lcd %:p:h<CR>
nnoremap <leader>td <cmd>e ~/todo.md<CR>
nnoremap <space>a ggVG
nnoremap <silent> <space><space> <cmd>noh<cr>
nnoremap gm <cmd>Git commit % -m ""<Left>
" close: closes a window (not a buffer..), allowing splits to work as intended
nnoremap <silent> <c-w> <cmd>close!<cr>
nnoremap cp yap<S-}>p
nnoremap J mzJ`z

nnoremap j gj
nnoremap k gk

nnoremap <C-j> <C-W>j
nnoremap <C-k> <C-W>k
nnoremap <C-l> <C-W>l
nnoremap <C-h> <C-W>h
nnoremap <c-e> <end>


" ===========================
" TERMINAL NAVIGATION
" ===========================
" 1. Escape Terminal Mode (<C-\><C-n>)
" 2. Execute Window Move (<C-w>j/k)
tnoremap <C-j> <C-\><C-n><C-w>j
tnoremap <C-k> <C-\><C-n><C-w>k

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

  echom "mark jumped"
  " Update mark to old cursor position
  call setpos("'z", cur_pos)
endfunction

" for vim9
inoremap <Nul> <C-o>:call InsertSetMark()<CR>
" for neovim
inoremap <C-Space> <C-o>:call InsertSetMark()<CR>
" works on both
inoremap <C-x> <C-o>:call InsertSwapMark()<CR>

vnoremap > >gv
vnoremap < <gv

" fix dot operator in visual select
xnoremap . :<C-u>normal! .<CR>

nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'
nnoremap <silent> <leader>n <cmd>e ~/notest.md<cr>
" nnoremap <esc>r :browse oldfiles<CR>
nnoremap  :browse oldfiles<CR>

"nnoremap <esc>k <cmd>cprev<cr>
"nnoremap <esc>j <cmd>cnext<cr>

" xnoremap p P
xnoremap p "_dP

" make dot operator work in visual mode
xnoremap . :normal .<CR>

" clear hlsearch on esc
" nnoremap <silent> <Esc> :noh<CR><Esc>

" nnoremap <leader>d <cmd>%bd!\|e#\|bd!#<CR>

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

vnoremap <enter> y/\V<C-r>=escape(@",'/\')<CR><CR>

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
" cant use this because it interferes with the " register command
" xnoremap " :<C-u>call WrapSelection('"', '"')<CR>
xnoremap ` :<C-u>call WrapSelection('`', '`')<CR>
xnoremap ( :<C-u>call WrapSelection('(', ')')<CR>
xnoremap [ :<C-u>call WrapSelection('[', ']')<CR>
" xnoremap { :<C-u>call WrapSelection('{', '}')<CR>
" xnoremap < :<C-u>call WrapSelection('<', '>')<CR>

" smart bracket insert on {<cr> etc
inoremap <expr> <CR> <SID>SmartEnter()

function! s:SmartEnter()
  let col = col('.')
  if col == 1
    return "\<CR>"
  endif

  let char = getline('.')[col - 2]

  if char == '{' || char == '[' || char == '('
    let close = char == '{' ? '}' : char == '[' ? ']' : ')'
    return "\<CR>" . close . "\<Esc>O"
  endif

  return "\<CR>"
endfunction

xnoremap H <gv
xnoremap L >gv
xnoremap <silent> y ygv<Esc>
xnoremap Q <cmd>norm @q<CR>

cnoremap <c-a> <Home>
cnoremap <c-b> <left>
cnoremap <c-e> <end>
" cnoremap <c-h> <Left>
cnoremap <c-l> <Right>

" use M-x
cnoremap <M-b>b <s-left>
cnoremap <M-f> <s-right>
cnoremap <A-BS> <c-w>
inoremap <C-BS> <c-w>
inoremap <D-y> <c-x><c-n>
"inoremap <C-s> <c-x><c-n>

inoremap <C-a> <C-o>^
" inoremap <C-a> <Home>
inoremap <C-e> <End>

inoremap <C-BS> <C-w>

if exists('$SSH_TTY') || $UID == 0
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

function! ToggleFolding()
  if &foldmethod ==# 'manual'
    setlocal foldenable foldmethod=indent foldlevel=0
    echo "Folding enabled, zk zj (jump folds)"
  else
    setlocal nofoldenable foldmethod=manual
    echo "Folding disabled"
  endif
endfunction

function! ToggleQuickfixList()
  let qf_exists = 0
  for win in getwininfo()
    if win.quickfix == 1
      let qf_exists = 1
      break
    endif
  endfor
  if qf_exists == 1
    cclose
  else
    copen
  endif
endfunction
" nnoremap <silent> <C-t> <cmd>call ToggleQuickfixList()<CR>

let g:term_buf = 0
let g:term_win = 0

function! ToggleTerminal()
    if g:term_win > 0 && win_gotoid(g:term_win)
        hide
        let g:term_win = 0
    else
        if g:term_buf > 0 && bufexists(g:term_buf)
            execute 'botright sbuffer' g:term_buf
            call feedkeys("i", "n")
        else
            botright terminal
            let g:term_buf = bufnr('%')
        endif
        let g:term_win = win_getid()
    endif
endfunction

nnoremap <silent> <C-t> :call ToggleTerminal()<CR>
tnoremap <silent> <C-t> <C-\><C-n>:call ToggleTerminal()<CR>

let g:term_zoomed = 0

function! ToggleTermZoom()
    if g:term_zoomed
        wincmd =
        let g:term_zoomed = 0
    else
        resize
        vertical resize
        let g:term_zoomed = 1
    endif
endfunction

tnoremap <silent> <C-y> <C-\><C-n>:call ToggleTermZoom()<CR>i


function s:remove_pair() abort
  let pair = getline('.')[ col('.')-2 : col('.')-1 ]
  return stridx('""''''()[]<>{}``', pair) % 2 == 0 ? "\<del>\<c-h>" : "\<bs>"
endfunction
inoremap <expr> <bs> <sid>remove_pair()

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
function! PasteOver()
     let s:restore_reg = @"
     return "p@=RestoreRegister()\<cr>"
endfunction
vnoremap <silent> <expr> p PasteOver()

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

autocmd BufReadPre * if getfsize(expand("%")) > 10000000 | setlocal noundofile nofoldenable noshowmatch | endif

augroup _resize
  autocmd!
  autocmd vimresized * :wincmd =
augroup end

augroup CleanOnWrite
  autocmd!
  autocmd BufWritePre * if line('$') < 5000 | call s:CleanAndSave() | endif
augroup end

augroup _quickfix
  autocmd!
  autocmd FileType qf nnoremap <buffer> <CR> <CR>
  autocmd QuickFixCmdPost [^l]* cwindow 6
  autocmd QuickFixCmdPost    l* lwindow 6
augroup end

let g:pyindent_continue = '&sw'
let g:pyindent_open_paren = '&sw'
let g:pyindent_nested_paren = '&sw'

augroup python_indent
  autocmd!
  autocmd FileType python setlocal expandtab shiftwidth=4 softtabstop=4 tabstop=8
augroup END

" Create autocommand group for filetype settings
augroup FileTypeSettings
  autocmd!
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

" Auto-format on save
if executable('black')
  autocmd BufWritePre *.py silent! execute '!black --quiet %' | edit!
endif

if executable('goimports')
  autocmd BufWritePre *.go silent! execute '%!goimports'
elseif executable('gofmt')
  autocmd BufWritePre *.go silent! execute '%!gofmt'
endif

if executable('prettier')
  autocmd BufWritePre *.md,*.json,*.yaml,*.yml,*.css,*.html,*.js,*.ts,*.jsx,*.tsx silent! execute '!prettier --write %' | edit!
endif

set formatoptions-=r formatoptions-=o formatoptions-=c

let g:netrw_keepdir = 0
let g:netrw_ssh_cmd = "ssh -o ControlMaster=auto -o ControlPath=/tmp/%r@%h:%p -o ControlPersist=5m"
let g:netrw_ssh_cmd = "ssh"

hi clear
if exists("syntax_on")
  syntax reset
endif

set background=dark

" ===========================
" CORE UI
" ===========================
" Background: #151F2D | Foreground: #BEBEBC
hi Normal       guifg=#BEBEBC guibg=#151F2D ctermfg=250 ctermbg=234
hi NormalNC     guifg=#BEBEBC guibg=#151F2D ctermfg=250 ctermbg=234
hi EndOfBuffer  guifg=#151F2D guibg=NONE    ctermfg=234 ctermbg=NONE

" Line Numbers & Cursor
hi LineNr       guifg=#3A4555 guibg=NONE    ctermfg=240
" Lua: CursorLineNr = bg=none. Changed FG from Yellow to Ayu Accent Orange
hi CursorLineNr guifg=#D89F5C guibg=NONE    ctermfg=179
" Lua: CursorLine links to Visual (#1F3350)
hi CursorLine   guibg=#1F3350               ctermbg=237
hi CursorColumn guibg=#1F3350               ctermbg=237
hi ColorColumn  guibg=#1F3350               ctermbg=237

" Lua: SignColumn = bg=none. Removed Cyan.
hi SignColumn   guifg=#3A4555 guibg=NONE    ctermfg=240
hi VertSplit    guifg=#151F2D guibg=#151F2D ctermfg=234 ctermbg=234
hi WinSeparator guifg=#151F2D guibg=#151F2D ctermfg=234 ctermbg=234

" ===========================
" VISUAL / SEARCH (TONED DOWN)
" ===========================
" Lua: Visual = { bg = "#1F3350" }
hi Visual       guifg=NONE    guibg=#1F3350 ctermfg=NONE ctermbg=60

hi Search       guifg=#151F2D guibg=#D89F5C ctermfg=234 ctermbg=179

" IncSearch: Dark text on Bright Orange (Active match pops slightly more)
hi IncSearch    guifg=#151F2D guibg=#FFB454 ctermfg=234 ctermbg=214

" Lua: MatchParen = { fg = "#151F2D", bg = "#BEBEBC" }
hi MatchParen   guifg=#151F2D guibg=#BEBEBC ctermfg=234  ctermbg=250

" ===========================
" POPUP MENU
" ===========================
" Toned down the bright blue selection to match Visual/Search vibe
hi Pmenu        guifg=#BEBEBC guibg=#1D2738 ctermfg=250 ctermbg=235
hi PmenuSel     guifg=#151F2D guibg=#BEBEBC ctermfg=234 ctermbg=250
hi PmenuSbar    guibg=#3A4555               ctermbg=240
hi PmenuThumb   guibg=#BEBEBC               ctermbg=250

" ===========================
" MESSAGES / MODE / SPECIAL
" ===========================
hi ErrorMsg     guifg=#D35A63 guibg=NONE    ctermfg=1   ctermbg=NONE
hi WarningMsg   guifg=#D89F5C guibg=NONE    ctermfg=179 ctermbg=NONE
hi MoreMsg      guifg=#BEBEBC               ctermfg=250
hi ModeMsg      guifg=#BEBEBC               ctermfg=250
hi Question     guifg=#AAD94C               ctermfg=10

" Fixed: Directory/Title were Cyan/Blue. Aligned with Ayu Types.
hi Title        guifg=#D89F5C               ctermfg=179
hi Directory    guifg=#7AA7D8               ctermfg=110

" Fixed: SpecialKey was Cyan. Made subtle Grey.
hi SpecialKey   guifg=#5F6C77               ctermfg=240
hi NonText      guifg=#5A6B85               ctermfg=240

" ===========================
" FOLDS
" ===========================
" Lua: Folded = { bg = "none" }. Fixed the Cyan FG.
hi Folded       guifg=#5F6C77 guibg=NONE    ctermfg=240 ctermbg=NONE
hi FoldColumn   guifg=#5F6C77 guibg=NONE    ctermfg=240 ctermbg=NONE

" ===========================
" DIFF (MATCHING LUA OVERRIDES)
" ===========================
" Lua: DiffAdd/Added = { fg = "#BEBEBC", bg = "#1C2E2E" }
hi DiffAdd      guifg=#BEBEBC guibg=#1C2E2E ctermfg=250 ctermbg=23
" Lua: DiffText = { fg = "#BEBEBC", bg = "#2A3245" }
hi DiffText     guifg=#BEBEBC guibg=#2A3245 ctermfg=250 ctermbg=60
" Lua: DiffChange (Line) - Subtle Blue-Grey
hi DiffChange   guifg=NONE    guibg=#223040 ctermfg=NONE ctermbg=24
" Lua: DiffDelete = { fg = "#222A38", bg = "none" }
hi DiffDelete   guifg=#222A38 guibg=NONE    ctermfg=235 ctermbg=NONE

" ===========================
" SPELLING
" ===========================
hi SpellBad     guifg=#D35A63 gui=undercurl ctermfg=1
hi SpellCap     guifg=#7AA7D8 gui=undercurl ctermfg=110
hi SpellRare    guifg=#D89F5C gui=undercurl ctermfg=179
hi SpellLocal   guifg=#AAD94C gui=undercurl ctermfg=10

" ===========================
" SYNTAX
" ===========================
hi Comment      guifg=#5F6C77 gui=italic    ctermfg=240
hi String       guifg=#8CA64A               ctermfg=107
hi Function     guifg=#AABFD9               ctermfg=153
hi Type         guifg=#7AA7D8               ctermfg=110
" Lua: Statement/Special = { fg = "#D89F5C" }
hi Statement    guifg=#D89F5C gui=bold      ctermfg=179
hi Special      guifg=#D89F5C               ctermfg=179
hi Keyword      guifg=#D89F5C               ctermfg=179
hi PreProc      guifg=#D89F5C               ctermfg=179

" Fixed: Identifier was Cyan (#40FFFF). Muted to FG or Type blue.
hi Identifier   guifg=#BEBEBC               ctermfg=250
hi Constant     guifg=#D89F5C               ctermfg=179

" Delimiters/Operators - Neutralized per Lua config
hi Delimiter    guifg=#BEBEBC               ctermfg=250
hi Operator     guifg=#BEBEBC               ctermfg=250

hi Todo         guifg=#D35A63 guibg=NONE    ctermfg=1 ctermbg=NONE
hi Error        guifg=#D35A63 guibg=NONE    ctermfg=1 ctermbg=NONE

" ===========================
" STATUSLINE (SUBTLE & VISIBLE)
" ===========================
" Active: Matches your Visual selection color. subtle but distinct.
hi StatusLine       guifg=#BEBEBC guibg=#1F3350 gui=NONE ctermfg=250 ctermbg=60

" Inactive: Very dark (darker than main bg). Creates a 'gutter' effect to show separation.
hi StatusLineNC     guifg=#5F6C77 guibg=#10151F gui=NONE ctermfg=240 ctermbg=233

" Terminal: Keep consistent (no green)
hi! link StatusLineTerm   StatusLine
hi! link StatusLineTermNC StatusLineNC

" Split Separators: Link to the inactive background for a clean border
hi VertSplit        guifg=#10151F guibg=#10151F ctermfg=233 ctermbg=233
hi WinSeparator     guifg=#10151F guibg=#10151F ctermfg=233 ctermbg=233
