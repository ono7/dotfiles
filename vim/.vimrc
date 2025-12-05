" 🐇 Follow the white Rabbit...

set nocompatible
filetype plugin indent on
syntax on

let mapleader = "\<Space>"

" let g:loaded_matchparen = 1
let g:matchparen_timeout = 20
let g:matchparen_insert_timeout = 20

if has("nvim")
  set shada='20,<2000,s200,:200,/200,h,f1,r/COMMIT_EDITMSG$
  packadd cfilter
  set inccommand=nosplit
  set pumheight=10 pumblend=0
  augroup UpdateShada
    autocmd!
    autocmd BufRead,BufNewFile * call insert(v:oldfiles, expand('%:p'), 0) | wshada
  augroup end
else
  set viminfo='20,<2000,s200,:200,/200,h,f1,r/COMMIT_EDITMSG$
  set ttyfast
  augroup UpdateViminfo
    autocmd!
    autocmd BufRead,BufNewFile * call insert(v:oldfiles, expand('%:p'), 0) | wviminfo
  augroup end
endif

if executable("rg")
  set grepprg=rg\ --vimgrep\ --smart-case\ --pcre2\ --no-messages\ 2>/dev/null

  function! Rg(args) abort
    execute "silent! grep!" shellescape(a:args)
    cwindow
    redraw!
  endfunction
  command -nargs=+ -complete=file Rg call Rg(<q-args>)

else
  set grepprg=grep\ -nHIRE\ --exclude-dir=.git\ --exclude-dir=node_modules
endif

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
set guicursor=n-v-c:block-Cursor/lCursor-blinkon0
set tags=./tags,tags;~
set shortmess=atcIoOsT
set laststatus=1
set encoding=utf-8 fileencoding=utf-8
set iskeyword+=_,-

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

command! Mktags call system('ctags -R .')
command! D bd!
command! Da %bd!

cnoreabbrev qq qa!

map Q <Nop>

" nnoremap ; :
" nnoremap : ;

" xnoremap ; :
" nnoremap v <c-v> " use c-q
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
nnoremap <silent> ,d <cmd>close!<cr>
nnoremap ,w <cmd>w!<cr>
nnoremap cp yap<S-}>p
nnoremap J mzJ`z

"nnoremap <expr> j v:count ? (v:count > 1 ? "m'" . v:count : '') . 'j' : 'gj'
"nnoremap <expr> k v:count ? (v:count > 1 ? "m'" . v:count : '') . 'k' : 'gk'
nnoremap j gj
nnoremap k gk

nnoremap <C-j> <C-W>j
nnoremap <C-k> <C-W>k
nnoremap <C-l> <C-W>l
nnoremap <C-h> <C-W>h
nnoremap <c-e> <end>
inoremap <C-f> <Esc>ea
inoremap <C-b> <C-o>b
inoremap <C-d> <C-o>D
inoremap <C-p> <C-r>"
nnoremap <C-n> <cmd>tabnew<cr>

nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'
nnoremap <silent> <leader>n <cmd>e ~/notest.md<cr>
nnoremap <M-r> :browse oldfiles<CR>
nnoremap <esc>r :browse oldfiles<CR>

"nnoremap <esc>k <cmd>cprev<cr>
"nnoremap <esc>j <cmd>cnext<cr>

" xnoremap p P
xnoremap p "_dP

" make dot operator work in visual mode
xnoremap . :normal .<CR>

" clear hlsearch on esc
" nnoremap <silent> <Esc> :noh<CR><Esc>

nnoremap <leader>d <cmd>%bd!\|e#\|bd!#<CR>
nnoremap <leader>d <cmd>bd!<CR>

vnoremap <enter> y/\V<C-r>=escape(@",'/\')<CR><CR>
vnoremap . <cmd>norm .<cr>

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
xnoremap { :<C-u>call WrapSelection('{', '}')<CR>
xnoremap < :<C-u>call WrapSelection('<', '>')<CR>

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
inoremap <C-y> <c-x><c-n>

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
hi Normal         guifg=#BEBEBC guibg=#151F2D ctermfg=250 ctermbg=234
hi NormalNC       guifg=#BEBEBC guibg=#151F2D ctermfg=250 ctermbg=234
hi EndOfBuffer    guifg=#151F2D               ctermfg=234
hi LineNr         guifg=#3A4555               ctermfg=240
hi CursorLineNr   guifg=Yellow                ctermfg=11
hi CursorLine     guibg=#1E2E45               ctermbg=237
hi CursorColumn   guibg=#2A3240               ctermbg=240
hi ColorColumn    guibg=#2A1A1A               ctermbg=52
hi! clear VertSplit
hi SignColumn     guifg=Cyan                  ctermfg=14

" ===========================
" VISUAL / SEARCH
" ===========================
hi Visual         guifg=#BEBEBC guibg=#223E65 ctermfg=250 ctermbg=60
hi Search         guifg=#FFFFFF guibg=#3A6FB0 ctermfg=15  ctermbg=68
hi IncSearch      guifg=#FFFFFF guibg=#3A6FB0 ctermfg=15  ctermbg=68
hi MatchParen     guifg=#151F2D guibg=#AABFD9 ctermfg=0 ctermbg=152

" ===========================
" POPUP MENU (FIXED READABILITY)
" ===========================
hi Pmenu          guifg=#BEBEBC guibg=#1D2738 ctermfg=250 ctermbg=235
hi PmenuSel       guifg=#FFFFFF guibg=#3A6FB0 ctermfg=15  ctermbg=68
hi PmenuSbar      guibg=#3A4555               ctermbg=240
hi PmenuThumb     guibg=#BEBEBC               ctermbg=250
hi PmenuShadow    guifg=#5A6B85 guibg=#000000 ctermfg=240 ctermbg=0

" ===========================
" MESSAGES / MODE / SPECIAL
" ===========================

hi ErrorMsg guifg=#D35A63 guibg=NONE ctermfg=1 ctermbg=NONE
hi Error    guifg=#D35A63 guibg=NONE ctermfg=1 ctermbg=NONE
hi WarningMsg     guifg=#D89F5C               ctermfg=179
hi MoreMsg        guifg=#BEBEBC               ctermfg=250
hi ModeMsg        guifg=#BEBEBC               ctermfg=250
hi Question       guifg=#AAD94C               ctermfg=10
hi Title          guifg=#AABFD9               ctermfg=153
hi Directory      guifg=Cyan                  ctermfg=14
hi SpecialKey     guifg=Cyan                  ctermfg=81
hi NonText        guifg=#5A6B85               ctermfg=12

" ===========================
" FOLDS
" ===========================
hi Folded         guifg=Cyan guibg=#2A3240    ctermfg=14 ctermbg=240
hi FoldColumn     guifg=Cyan guibg=#2A3240    ctermfg=14 ctermbg=240

" ===========================
" DIFF (FLAT + MODERN)
" ===========================
hi DiffAdd        guifg=#BEBEBC guibg=#1C2E2E ctermfg=250 ctermbg=23
hi DiffChange     guifg=#BEBEBC guibg=#223040 ctermfg=250 ctermbg=24
hi DiffDelete     guifg=#222A38 guibg=#2A1A1A ctermfg=235 ctermbg=52
hi DiffText       guifg=#FFFFFF guibg=#2A3245 ctermfg=15  ctermbg=60

" ===========================
" SPELLING
" ===========================
hi SpellBad       guifg=#D35A63               ctermfg=1
hi SpellCap       guifg=#7AA7D8               ctermfg=110
hi SpellRare      guifg=#C07035               ctermfg=173
hi SpellLocal     guifg=Cyan                  ctermfg=14

" ===========================
" SYNTAX (FLATTENED)
" ===========================
hi Comment        guifg=#5F6C77               ctermfg=240
hi Constant       guifg=#FFA0A0               ctermfg=217
hi String         guifg=#8CA64A               ctermfg=107
hi Function       guifg=#AABFD9               ctermfg=153
hi Statement      guifg=#D89F5C               ctermfg=179
hi Type           guifg=#7AA7D8               ctermfg=110
hi Special        guifg=#C07035               ctermfg=173
hi Identifier     guifg=#40FFFF               ctermfg=51
hi PreProc        guifg=#FF80FF               ctermfg=13
hi Underlined     guifg=#80A0FF               ctermfg=75
hi Ignore         guifg=#151F2D               ctermfg=234
hi Error          guifg=#D35A63               ctermfg=1
hi Todo           guifg=#D35A63 guibg=#3A6FB0 ctermfg=1 ctermbg=68
