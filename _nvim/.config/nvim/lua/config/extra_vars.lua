M = {}

M.legacy_cfg = [===[
" --- 🐇 Follow the white Rabbit...

set nocompatible

set t_Co=8

nnoremap <space> <nop>
nnoremap <M-e> <nop>
inoremap <M-e> <nop>
inoremap <M-C-U> <nop>

let mapleader = " "


let g:loaded_matchit = 1
let g:loaded_logiPat = 1
let g:loaded_rrhelper = 1
let g:loaded_tarPlugin = 1
let g:loaded_zipPlugin = 1
let g:loaded_2html_plugin = 1
let g:loaded_shada_plugin = 1
let g:loaded_spellfile_plugin = 1
let g:loaded_tutor_mode_plugin = 1
let g:loaded_remote_plugins = 1

let g:diff_translations = 0
let g:pyindent_open_paren = '0'
let g:pyindent_nested_paren = '&sw'
let g:pyindent_continue = '&sw'

let g:netrw_localcopydircmd = 'cp -r'

" use osc52 to copy to tmux
function! CopyToClipboard(text)
  let l:encoded = system('printf "%s" ' . a:text . ' | base64')
  call system('printf "\e]52;c;' . l:encoded . '\a"')
endfunction

" Normal mode mapping
nnoremap <leader>y :call CopyToClipboard(@0)<CR>

" Visual mode mapping
vnoremap <leader>y :<C-u>call CopyToClipboard(@0)<CR>

" remove ~
let &fcs='eob: '

set synmaxcol=512
syntax sync minlines=256
syntax sync maxlines=300
filetype plugin indent on
syntax off

""" hold my beer """

nnoremap <expr> k (v:count > 1 ? "m'" . v:count : '') . 'k'
nnoremap <expr> j (v:count > 1 ? "m'" . v:count : '') . 'j'

inoremap <expr> <bs> <sid>remove_pair()
inoremap <expr> <enter> <sid>indent_ret()

" Line navigation
inoremap <C-a> <Esc>^i
inoremap <C-e> <End>

" Shift-> to indent last pasted text to the right
nnoremap > mz`[V`]>`z

" Shift-< to indent last pasted text to the left
nnoremap < mz`[V`]<`z

function! CopyMatches(reg)
  let hits = []
  %s//\=len(add(hits, submatch(0))) ? submatch(0) : ''/gne
  let reg = empty(a:reg) ? '+' : a:reg
  execute 'let @'.reg.' = join(hits, "\n") . "\n"'
endfunction
command! -register Cm call CopyMatches(<q-reg>)

function s:remove_pair() abort
  let pair = getline('.')[ col('.')-2 : col('.')-1 ]
  return stridx('""''''()[]<>{}``', pair) % 2 == 0 ? "\<del>\<c-h>" : "\<bs>"
endfunction

function! s:smart_indent_ret() abort
    let line = getline('.')
    let col = col('.')
    let prev_char = line[col-2]

    if prev_char == '{'
        return "\<CR>\<CR>}\<Up>\<Tab>"
    elseif prev_char == '['
        return "\<CR>\<CR>]\<Up>\<Tab>"
    elseif prev_char == '('
        return "\<CR>\<CR>)\<Up>\<Tab>"
    else
        return "\<CR>"
    endif
endfunction

inoremap <expr> <CR> <SID>smart_indent_ret()

" vnoremap ' <esc>`>a'<esc>`<i'<esc>f'a
" vnoremap " <esc>`>a"<esc>`<i"<esc>f"a
" vnoremap ` <esc>`>a`<esc>`<i`<esc>f`a
" vnoremap [ <esc>`>a]<esc>`<i[<esc>f]a
" vnoremap { <esc>`>a}<esc>`<i{<esc>f}a
" vnoremap ( <esc>`>a)<esc>`<i(<esc>f)a

" clear hsl
nnoremap <silent> <Esc> :nohlsearch<CR>:echo<CR>
nnoremap <c-t> <cmd>new<cr>

nnoremap <c-j> <C-W><C-J>
nnoremap <c-k> <C-W><C-K>
nnoremap <c-l> <C-W><C-L>
nnoremap <c-h> <C-W><C-H>
nnoremap 0 ^

" save some keystrokes
xnoremap H <gv
xnoremap L >gv

" switch between current and prev file
nnoremap <c-6> c-^>

nnoremap v <c-v>

vnoremap p "0p
vnoremap P "0P
vnoremap d "0d

inoremap <C-c> <Esc>

" change local cd per buffer
nnoremap <leader>cd :tcd %:h<CR>

" Word movement
inoremap <M-f> <C-o>w
inoremap <M-b> <C-o>b

inoremap <C-a> <Home>
inoremap <C-e> <End>

cnoremap <C-A> <Home>
cnoremap <C-h> <Left>
cnoremap <C-l> <Right>
cnoremap <D-A> <Home>
cnoremap <D-h> <Left>
cnoremap <D-l> <Right>
nnoremap <silent><cr> :noh<cr>1<c-g>
nnoremap <silent><m-k> :cnext<cr>
nnoremap <silent><m-j> :cprevious<cr>
nnoremap <leader>d :bd!<cr>
nnoremap <leader>w :w<cr>

" return cursor position after yank in v-mode
vnoremap y ygv<Esc>

" paste matches indentation
nnoremap p p=`]

nnoremap ' `
nnoremap ma mA
nnoremap mb mB
nnoremap mc mC
nnoremap mm mM
" '" -> go to mark and restore last cursor postion
nnoremap 'a `A'"
nnoremap 'b `B'"
nnoremap 'c `C'"
nnoremap 'm `M'"

nnoremap Q @qj
xnoremap Q :norm @q<cr>
" make dot work on many visual sel lines
vnoremap . :norm.<CR>
nnoremap Y y$
nnoremap D d$
nnoremap cp yap<S-}>p
nnoremap U <c-r>
nnoremap <c-e> g_

" select last paste in visual mode
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'

vnoremap <enter> y/\V<C-r>=escape(@",'/\')<CR><CR>

nnoremap <leader>b :set nomore <Bar> :ls <Bar> :set more <CR>:b<Space>
nnoremap <c-s> :bro oldfiles<CR>

" Set ripgrep as the grep program
set grepprg=rg\ --vimgrep\ --smart-case\ --pcre2
set grepformat=%f:%l:%c:%m,%f

" Create Rg command
command! -nargs=+ Rg call RgSearch(<q-args>)

function! RgSearch(args)
    if a:args != ""
        " Execute ripgrep and capture output
        let cmd = 'rg --vimgrep --smart-case --pcre2 ' . shellescape(a:args)
        let output = system(cmd)
        
        " Check if ripgrep succeeded
        if v:shell_error == 0
            " Split output into lines and filter empty lines
            let lines = filter(split(output, '\n'), 'v:val != ""')
            
            " Set quickfix list
            call setqflist([], 'r', {
                \ 'title': 'rg: ' . a:args,
                \ 'lines': lines
                \ })
            
            " Open quickfix window
            copen
        else
            echo "No matches found"
        endif
    endif
endfunction

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

cnoreabbrev qq qa!

set completeopt=longest
set pumheight=10
set notitle

" ~ search upwards until home dir
set tags=./tags,tags;~
set virtualedit=all
set path+=**
set whichwrap+=<>[]hl
set autoread
set backspace=indent,eol,start
set background=dark
set cmdheight=1
set complete=.,w,b,u
set diffopt=filler
set directory=
set viminfo='20,<1000,s100,:100,/100,h
set display+=lastline
set encoding=utf-8
set fileencoding=utf-8
set fillchars+=vert:│,diff:╱
set hidden
set history=1000
set ignorecase
set incsearch
set nohlsearch
set mouse=n
set laststatus=1
set magic
set nobackup nowritebackup noswapfile
set nojoinspaces
set list
set listchars=conceal:\ ,trail:\ ,nbsp:\
set noshowcmd
set showtabline=0
set novisualbell noerrorbells
set nowrap
set nrformats-=octal nrformats+=alpha
set numberwidth=2
set number
set relativenumber
set ruler
set shiftround shiftwidth=2
set shortmess=atcIoOsT
" set showmode
set sidescrolloff=1
set smartcase smarttab
set spelllang=en_us
set nosplitbelow
set splitright
set softtabstop=2 tabstop=2 textwidth=0 expandtab
set timeout ttimeout
" set timeoutlen=500 ttimeoutlen=0
set undolevels=999
set undodir=/tmp
set undofile
set updatetime=1000
set fileformats=unix
set autoindent
set nolisp
set iskeyword+=-

" Base wildignore setup
set wildignore=

" General ignores (OS, editors, etc.)
set wildignore+=**/.DS_Store,**/Thumbs.db,**/Desktop.ini
set wildignore+=**/.git/**,**/.svn/**,**/.hg/**
set wildignore+=**/.idea/**,**/.vscode/**
set wildignore+=**/*.tmp,**/*.temp,**/*.swp,**/*.swo,**/*~
set wildignore+=.tags,tags

" Shared build/cache/temp directories
set wildignore+=**/.cache/**,**/build/**,**/dist/**,**/out/**
set wildignore+=**/target/**,**/coverage/**,**/tmp/**
set wildignore+=**/.tmp/**,**/.temp/**,**/logs/**,**/.logs/**
set wildignore+=**/*.log

" Python-specific ignores
set wildignore+=**/__init__.py,**/test_*.py,**/*_test.py,**/conftest.py
set wildignore+=**/__pycache__/**,**/venv/**,**/.venv/**
set wildignore+=**/env/**,**/.env/**,**/virtualenv/**
set wildignore+=**/.pytest_cache/**,**/.coverage,**/htmlcov/**
set wildignore+=**/.tox/**,**/*.egg-info/**,**/*.egg/**
set wildignore+=**/wheels/**,**/.mypy_cache/**,**/.ruff_cache/**
set wildignore+=**/site-packages/**,**/*.pyc,**/*.pyo,**/*.pyd
set wildignore+=**/pip-log.txt,**/pip-delete-this-directory.txt

" JavaScript/TypeScript/Node.js ignores
set wildignore+=**/node_modules/**,**/npm-debug.log*
set wildignore+=**/yarn-debug.log*,**/yarn-error.log*
set wildignore+=**/.npm/**,**/.yarn/**,**/package-lock.json
set wildignore+=**/yarn.lock,**/pnpm-lock.yaml,**/.next/**
set wildignore+=**/.nuxt/**,**/.output/**,**/.nyc_output/**
set wildignore+=**/.parcel-cache/**,**/jspm_packages/**
set wildignore+=**/bower_components/**,**/*.min.js,**/*.min.css
set wildignore+=**/.eslintcache,**/.stylelintcache
set wildignore+=**/tsconfig.tsbuildinfo,**/.turbo/**

" Go ignores
set wildignore+=**/vendor/**,**/*.exe,**/go.sum
set wildignore+=**/bin/**,**/.bin/**

" Database ignores
set wildignore+=**/*.sqlite,**/*.db,**/*.sqlite3

" Documentation/Media
set wildignore+=**/*.pdf,**/*.doc,**/*.docx
set wildignore+=**/*.jpg,**/*.jpeg,**/*.png,**/*.gif
set wildignore+=**/*.ico,**/*.svg,**/*.mp3,**/*.mp4
set wildignore+=**/*.avi,**/*.mov

if has('unnamedplus')
  set clipboard=unnamedplus
else
  set clipboard=unnamed
endif

if has('nvim')
  packadd cfilter
  set inccommand=nosplit
  " pmenu/transparency/max items
  set pumheight=10 pumblend=0
  tnoremap <c-[> <C-\><C-n>
  set clipboard+=unnamedplus
endif

if &diff
  if has('nvim-0.3.2')
    set diffopt=filler,internal,algorithm:histogram,indent-heuristic
  endif
  set number
endif

function! <SID>RemoveWhiteSpace()
  let l = line(".")
  let c = col(".")
  %s/\s\+$//e
  call cursor(l, c)
endfunction
command! RemoveWhiteSpace call <SID>RemoveWhiteSpace()

fun! <SID>TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun

augroup _del_hidden_buffer
  au!
  au FileType netrw setlocal bufhidden=wipe
augroup end

augroup _read
  autocmd!
  " restore last known position
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
augroup END

augroup _write
  autocmd!
  autocmd BufWritePre * silent! :retab!
  autocmd BufWritePre * call <SID>TrimWhitespace()
augroup END

augroup _resize
  autocmd!
  autocmd vimresized * :wincmd =
augroup end

augroup _quickfix
  autocmd!
  " auto open quickfix
  autocmd FileType qf nnoremap <buffer> <CR> <CR>
  autocmd QuickFixCmdPost [^l]* cwindow 6
  autocmd QuickFixCmdPost    l* lwindow 6
augroup END

command! Mktags !ctags -R .

hi! clear MatchParen
hi! MatchParen term=reverse cterm=reverse gui=reverse

augroup _clean
  " clean empty lines at end of file
  autocmd!
  autocmd BufWritePre * :%s#\($\n\s*\)\+\%$##e
augroup END

hi! clear Error
hi! clear ModeMsg
hi! Comment ctermfg=8 ctermbg=NONE guifg=DarkGrey guibg=NONE
hi! link LineNr Comment
hi! link SpecialKey Comment
hi! StatusLine guibg=#444d69
hi! Visual guibg=#243d61
hi! Normal guibg=NONE ctermbg=NONE

set guicursor=

]===]

return M
