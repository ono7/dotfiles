" 🐇 Follow the white Rabbit...

set nocompatible
filetype plugin indent on
syntax off

let mapleader = "\<Space>"

" let g:loaded_matchparen = 1
let g:matchparen_timeout = 20
let g:matchparen_insert_timeout = 20

if has("nvim")
  set shada='20,<1000,s100,:100,/100,h,r/COMMIT_EDITMSG$
  packadd cfilter
  set inccommand=nosplit
  set pumheight=10 pumblend=0
  augroup UpdateShada
    autocmd!
    autocmd BufRead,BufNewFile * call insert(v:oldfiles, expand('%:p'), 0) | wshada
  augroup end
else
  set viminfo='20,<1000,s100,:100,/100,h,f1,r/COMMIT_EDITMSG$
  set ttyfast
  augroup UpdateViminfo
    autocmd!
    autocmd BufRead,BufNewFile * call insert(v:oldfiles, expand('%:p'), 0) | wviminfo
  augroup end
endif

if executable("rg")
  set grepprg=rg\ --vimgrep\ --smart-case\ --pcre2\ --no-messages\ 2>/dev/null
else
  set grepprg=grep\ -nHIRE\ --exclude-dir=.git\ --exclude-dir=node_modules
endif

set undolevels=999
if !isdirectory($HOME."/.vim-undo")
    call mkdir($HOME."/.vim-undo", "p", 0700)
endif
set undodir=~/.vim-undo
set undofile

set t_Co=8
set path=.,**
setlocal path=.,**

set sw=2 ts=2
set wildmenu wildmode=longest:full,full wildignorecase
set foldenable foldmethod=indent foldlevelstart=99 foldlevel=0 foldnestmax=2
set lazyredraw hidden undolevels=1000 updatetime=300
set incsearch ignorecase smartcase autoindent smartindent
set number relativenumber nocursorline
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
set guicursor=
set tags=./tags,tags;~
set shortmess=atcIoOsT
set laststatus=1
set encoding=utf-8 fileencoding=utf-8
set iskeyword+=_,-

try
  tnoremap jj <C-\><C-n>
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

"if has('clipboard')
"  if has('mac') || !empty($DISPLAY)
"    if has('unnamedplus')
"      set clipboard=unnamedplus
"    else
"      set clipboard=unnamed
"    endif
"  endif
"endif

" Optimized clipboard configuration with proper fallbacks
if has('clipboard')
  if has('unnamedplus')
    set clipboard=unnamedplus,unnamed
  elseif has('unnamed')
    set clipboard=unnamed
  endif
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

cnoreabbrev qq qa!

map Q <Nop>

nnoremap v <c-v>
nnoremap U <c-r>
nnoremap <c-r> <cmd>browse oldfiles<CR>
nnoremap Y yg_
nnoremap D d$
nnoremap <leader>cd <cmd>lcd %:p:h<CR>
nnoremap <leader>td <cmd>e ~/todo.md<CR>
nnoremap <space>a ggVG
nnoremap <silent> <space><space> <cmd>noh<cr>
nnoremap gm <cmd>Git commit % -m ""<Left>
nnoremap <silent> ,d <cmd>bd!<cr>
nnoremap ,w <cmd>w!<cr>
nnoremap cp yap<S-}>p
nnoremap J mzJ`z

nnoremap <expr> j v:count ? (v:count > 1 ? "m'" . v:count : '') . 'j' : 'gj'
nnoremap <expr> k v:count ? (v:count > 1 ? "m'" . v:count : '') . 'k' : 'gk'

nnoremap <C-j> <C-W>j
nnoremap <C-k> <C-W>k
nnoremap <C-l> <C-W>l
nnoremap <C-h> <C-W>h
nnoremap <c-e> <end>

nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'
nnoremap <silent> <leader>n <cmd>e ~/notest.md<cr>
nnoremap <M-r> :browse oldfiles<CR>
nnoremap <esc>r :browse oldfiles<CR>
nnoremap <esc>k <cmd>cprev<cr>
nnoremap <esc>j <cmd>cnext<cr>
nnoremap <leader>d <cmd>%bdelete\|edit#\|bdelete#<CR>

vnoremap <enter> y/\V<C-r>=escape(@",'/\')<CR><CR>
vnoremap . <cmd>norm .<cr>

xnoremap ' <esc>`>a'<esc>`<i'<esc>f'a
xnoremap " <esc>`>a"<esc>`<i"<esc>f"a
xnoremap ` <esc>`>a`<esc>`<i`<esc>f`a
xnoremap ( <esc>`>a)<esc>`<i(<esc>
xnoremap [ <esc>`>a]<esc>`<i[<esc>
xnoremap { <esc>`>a}<esc>`<i{<esc>
xnoremap < <esc>`>a><esc>`<i<<esc>

xnoremap H <gv
xnoremap L >gv
xnoremap <silent> y ygv<Esc>
xnoremap Q <cmd>norm @q<CR>

cnoremap <c-a> <Home>
cnoremap <c-b> <left>
cnoremap <c-e> <end>
cnoremap <c-h> <Left>
cnoremap <c-l> <Right>

" use M-x
cnoremap <M-b>b <s-left>
cnoremap <M-f> <s-right>
cnoremap <A-BS> <c-w>
inoremap <C-BS> <c-w>

inoremap <C-a> <Home>
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

"function! Rg(args) abort
"  execute "silent! grep!" shellescape(a:args)
"  cwindow
"  redraw!
"endfunction
"command -nargs=+ -complete=file Rg call Rg(<q-args>)
"nnoremap <M-g> <cmd>Rg<space>
"nnoremap <esc>g <cmd>Rg<space>

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
nnoremap <silent> <C-t> <cmd>call ToggleQuickfixList()<CR>

function s:remove_pair() abort
  let pair = getline('.')[ col('.')-2 : col('.')-1 ]
  return stridx('""''''()[]<>{}``', pair) % 2 == 0 ? "\<del>\<c-h>" : "\<bs>"
endfunction
inoremap <expr> <bs> <sid>remove_pair()

function! CopyMatches(reg)
  let hits = []
  %s//\=len(add(hits, submatch(0))) ? submatch(0) : ''/gne
  let reg = empty(a:reg) ? '+' : a:reg
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
" 10MB
"autocmd BufReadPre * if getfsize(expand("%")) > 10000000 | setlocal noundofile nofoldenable | endif
autocmd BufReadPre * if getfsize(expand("%")) > 10000000 | setlocal noundofile nofoldenable noshowmatch | endif

augroup _read
  autocmd!
  " restore last known position
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
augroup end

augroup _resize
  autocmd!
  autocmd vimresized * :wincmd =
augroup end

augroup CleanOnWrite
  autocmd!
  autocmd BufWritePre * call s:CleanAndSave()
augroup end

augroup _quickfix
  autocmd!
  autocmd FileType qf nnoremap <buffer> <CR> <CR>
  autocmd QuickFixCmdPost [^l]* cwindow 6
  autocmd QuickFixCmdPost    l* lwindow 6
augroup end

" Create autocommand group for filetype settings
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
  autocmd FileType markdown setlocal fo+=n fo+=t fo+=j conceallevel=2
augroup end

set formatoptions-=r formatoptions-=o formatoptions-=c

let g:netrw_keepdir = 0
let g:netrw_ssh_cmd = "ssh -o ControlMaster=auto -o ControlPath=/tmp/%r@%h:%p -o ControlPersist=5m"
let g:netrw_ssh_cmd = "ssh"

hi! Comment ctermfg=8 ctermbg=NONE guifg=#384057 guibg=NONE
hi! link LineNr Comment
hi! clear Error
hi! clear ModeMsg
hi! clear DiffDelete
hi! clear FoldColumn
hi! clear SignColumn
hi! clear CursorLineFold
hi! link CursorLine Normal
hi! CursorLineFold guibg=NONE guifg=NONE ctermbg=NONE
hi! SignColumn guibg=NONE guifg=NONE ctermbg=NONE
hi! FoldColumn guibg=NONE guifg=NONE ctermbg=NONE
hi! clear DiffAdd
" hi! DiffChange term=bold ctermbg=0 guibg=NONE
hi! DiffChange ctermbg=52  ctermfg=NONE guibg=#3a1e1e guifg=NONE
hi! DiffText term=bold ctermbg=3 ctermfg=0 guifg=#000000 guibg=#e1ca97
hi! DiffAdd term=bold gui=bold ctermfg=14 ctermbg=NONE guibg=NONE guifg=#93b5b3
hi DiffChange ctermbg=NONE ctermfg=11 guibg=#0F1724 guifg=#ffff00
hi! clear ErrorMsg
hi! clear MatchParen
hi! Visual term=reverse cterm=reverse gui=reverse
hi! MatchParen guibg=#384057 ctermbg=8
hi! Search term=reverse cterm=reverse gui=reverse
hi! PmenuSel term=reverse cterm=reverse gui=reverse
hi! Pmenu term=reverse cterm=reverse gui=reverse
hi! clear Pmenu
hi! Normal guibg=NONE guifg=NONE ctermbg=NONE
hi! link LineNr Comment
hi! link DiffDelete Comment
hi! link SpecialKey Comment
hi! link Folded Comment
hi! link VertSplit Comment
hi! link MsgSeparator Comment
hi! link WinSeparator Comment
hi! link EndOfBuffer Comment
hi! link StatusLineNC Comment
