" 🐇 Follow the white Rabbit...

set nocompatible
filetype plugin indent on
syntax off

let mapleader = " "

if has("nvim")
  set shada='20,<1000,s100,:100,/100,h,r/COMMIT_EDITMSG$
  packadd cfilter
  set inccommand=nosplit
  set pumheight=10 pumblend=0
  tnoremap <c-[> <C-\><C-n>
else
  set viminfo='20,<1000,s100,:100,/100,h,f1,r/COMMIT_EDITMSG$
  set ttyfast
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
set path=.,,**
set sw=2 ts=2
set wildmenu wildmode=longest:full,full wildignorecase
set foldenable foldmethod=indent foldlevelstart=99 foldlevel=0 foldnestmax=2
set lazyredraw hidden undolevels=1000
set incsearch ignorecase smartcase autoindent smartindent
set number relativenumber
set magic noshowcmd nowrap
set timeout timeoutlen=300 ttimeout ttimeoutlen=50
set scrolloff=3 sidescrolloff=5 nowrap
set backspace=indent,eol,start
set nobackup nowritebackup noswapfile
set fillchars+=vert:│
set fillchars+=diff:╱
let &showbreak="↪ "
set splitbelow splitright
set fileformats=unix
set guicursor=
set tags=./tags,tags;~
set shortmess=atcIoOsT
set laststatus=1

try
  set diffopt=filler,context:3,internal,algorithm:histogram,indent-heuristic
catch
  set diffopt=filler,context:3,internal
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

if has('clipboard') && !empty($DISPLAY)
  if has('unnamedplus')
    set clipboard=unnamedplus
  else
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

command! Mktags !ctags -R .

cnoreabbrev qq qa!

map Q <Nop>

nnoremap v <c-v>
nnoremap U <c-r>
nnoremap <c-r> :browse oldfiles<CR>
nnoremap Y yg_
nnoremap D d$
nnoremap <leader>cd :lcd %:h<CR>
nnoremap <space>a ggVG
nnoremap <silent> <space><space> :noh<cr>
nnoremap ,d :bd!<cr>
nnoremap ,w :w!<cr>

vnoremap <enter> y/\V<C-r>=escape(@",'/\')<CR><CR>

nnoremap <expr> k (v:count > 1 ? "m'" . v:count : '') . 'k'
nnoremap <expr> j (v:count > 1 ? "m'" . v:count : '') . 'j'

nnoremap <C-j> <C-W>j
nnoremap <C-k> <C-W>k
nnoremap <C-l> <C-W>l
nnoremap <C-h> <C-W>h
" nnoremap gp `[v`]
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'

nnoremap <M-r> :browse oldfiles<CR>
nnoremap r :browse oldfiles<CR>

xnoremap ' <esc>`>a'<esc>`<i'<esc>f'a
xnoremap " <esc>`>a"<esc>`<i"<esc>f"a
xnoremap ` <esc>`>a`<esc>`<i`<esc>f`a

cnoremap <C-A> <Home>
cnoremap <C-h> <Left>
cnoremap <C-l> <Right>

inoremap <C-a> <Home>
inoremap <C-e> <End>

xnoremap H <gv
xnoremap L >gv

function! Rg(args) abort
  execute "silent! grep!" shellescape(a:args)
  cwindow
  redraw!
endfunction
command -nargs=+ -complete=file Rg call Rg(<q-args>)
nnoremap <M-g> :Rg<space>
nnoremap g  :Rg<space>

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
nnoremap <silent> <C-t> :call ToggleQuickfixList()<CR>

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
autocmd BufReadPre * if getfsize(expand("%")) > 10000000 | setlocal noundofile nofoldenable | endif

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
augroup END

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
  autocmd FileType typescript,javascript,typescriptreact,javascriptreact,json,yaml,yml setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab

  " Go - 4-width tabs
  autocmd FileType go setlocal tabstop=4 softtabstop=4 shiftwidth=4 noexpandtab

  " Shell scripts - 2 spaces
  autocmd FileType sh,bash,zsh setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab

  " Makefiles - tabs (required)
  autocmd FileType make setlocal tabstop=4 softtabstop=4 shiftwidth=4 noexpandtab

  " Jinja templates - 2 spaces
  autocmd FileType jinja,jinja2 setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
augroup END

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

hi! Comment ctermfg=8 ctermbg=NONE guifg=#384057 guibg=NONE
hi! link LineNr Comment
hi! clear Error
hi! clear ModeMsg
hi! clear DiffDelete
hi! clear FoldColumn
hi! DiffChange term=bold ctermbg=NONE guibg=NONE
hi! DiffText term=bold ctermbg=3 ctermfg=0 guifg=#000000 guibg=#e1ca97
hi! DiffAdd term=bold ctermbg=2 ctermfg=0 guifg=#000000 guibg=#93b5b3
hi! clear ErrorMsg
hi! Visual term=reverse cterm=reverse gui=reverse
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
