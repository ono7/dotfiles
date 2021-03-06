" Follow the white rabbit...

nnoremap Q <Nop>
nnoremap gQ <Nop>

" visual select mode
nnoremap gh <Nop>
nnoremap gH <Nop>

let mapleader = " "

" disable ale lsp before plugins are loaded
let g:ale_disable_lsp = 1

" neovim providers
let g:loaded_ruby_provider = 0
let g:loaded_perl_provider = 0
let g:loaded_python_provider = 1
let g:python3_host_prog = $HOME."/.virtualenvs/prod3/bin/python3"

filetype off

" auto install plug
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

if !empty(glob('~/.vim/autoload/plug.vim'))
  call plug#begin('~/.config/nvim/plugged')
    Plug 'christoomey/vim-tmux-navigator'
    Plug 'jiangmiao/auto-pairs'
    Plug 'Glench/Vim-Jinja2-Syntax', { 'for' : 'jinja' }
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
    Plug 'junegunn/fzf.vim'
    Plug 'ervandew/supertab'
    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-commentary'
    Plug 'tpope/vim-eunuch'
    Plug 'tpope/vim-repeat'
    Plug 'tpope/vim-markdown', {'for' : 'markdown'}
    Plug 'scrooloose/nerdtree',{ 'on': ['NERDTreeToggle', 'NERDTree', 'NERDTreeFind', 'NERDTreeClose'] }
    Plug 'vimwiki/vimwiki'
    if has('nvim')
      " Plug 'norcalli/nvim-colorizer.lua'
      Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
      Plug 'nvim-treesitter/playground'
      Plug 'bfredl/nvim-miniyank'
      Plug 'SirVer/ultisnips'
      Plug 'lukas-reineke/format.nvim'
      Plug 'dense-analysis/ale', { 'for' : ['yaml', 'python', 'javascript', 'typescript', 'json', 'ruby', 'cs', 'lua' ] }
      Plug 'davidhalter/jedi-vim', { 'for' : ['python'] }
      Plug 'neoclide/coc.nvim', {'branch': 'release',
            \ 'for' : [
            \ 'python', 'jinja','json', 'javascript', 'css', 'typescript',
            \ 'terraform', 'cs', 'lua', 'yaml' ]}
    endif
    " Plug 'Yggdroot/indentLine', { 'on' : ['IndentLinesToggle','IndentLinesEnable']}
  call plug#end()
endif

filetype plugin indent on

syntax on

" lua hi
let g:vimsyn_embed = 'l'

set synmaxcol=0
syntax sync minlines=256
syntax sync maxlines=300

set termguicolors
set background=dark
colorscheme onehalfdark

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                  treesitter                                  "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if has('nvim')
lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  highlight = {
    enable = true,              -- false will disable the whole extension
    disable = { "rust" },  -- list of language that will be disabled
  },
  playground = {
    enable = true,
    disable = {},
    updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
    persist_queries = false -- Whether the query persists across vim sessions
  },
}
EOF
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                vim functions                                 "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! NerdTreeToggleFind()
  if exists("g:NERDTree") && g:NERDTree.IsOpen()
    NERDTreeClose
  elseif filereadable(expand('%'))
    NERDTreeFind
  else
    NERDTree
  endif
endfunction

function! FZFOpen(command_str)
  " prevents nerdtree window from being used when opening files through fzf search
  if (expand('%') =~# 'NERD_tree' && winnr('$') > 1)
    exe "normal! \<c-w>\<c-w>"
    setlocal noincsearch
  endif
  exe 'normal! ' . a:command_str . "\<cr>"
endfunction

function! <SID>StripTrailingWhitespaces()
  let l = line(".")
  let c = col(".")
  %s/\s\+$//e
  %s#\($\n\s*\)\+\%$##e
  call cursor(l, c)
endfunction
command! RemoveTrailingWhiteSpaces call <SID>StripTrailingWhitespaces()

function! CopyMatches(reg)
  " copy matches to main clipboard :CopyMatches *
  let hits = []
  %s//\=len(add(hits, submatch(0))) ? submatch(0) : ''/gne
  let reg = empty(a:reg) ? '+' : a:reg
  execute 'let @'.reg.' = join(hits, "\n") . "\n"'
endfunction
command! -register JcopyMatches call CopyMatches(<q-reg>)

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                  autogroup                                   "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

augroup _init
  autocmd!
  autocmd BufWinEnter * if line2byte(line("$") + 1) > 1000000 | syntax clear | setlocal nowrap | setlocal eventignore=all | endif
  autocmd VimEnter * command! -bang -nargs=? GFiles call fzf#vim#gitfiles(<q-args>, {'options': '--no-preview'}, <bang>0)
  autocmd VimEnter * command! -bang -nargs=? Files call fzf#vim#files(<q-args>, {'options': '--no-preview'}, <bang>0)
augroup END

augroup _resize
  autocmd!
  " resize splits when terminal size changes
  autocmd VimResized * :wincmd =
augroup END

augroup _read
  autocmd!
  " restore last known position
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
  autocmd BufEnter * silent! lcd %:p:h
augroup END

augroup _write
  autocmd!
  autocmd BufWritePre * silent! :call <SID>StripTrailingWhitespaces() | retab
  " Plug 'lukas-reineke/format.nvim'
  autocmd BufWritePost * FormatWrite
augroup END

augroup _set_type
  autocmd!
  autocmd BufNewFile,BufRead,BufEnter *.asm,*.nasm setfiletype nasm
  " autocmd BufNewFile,BufRead,BufEnter *.yml,*.yaml setfiletype ansible.yaml
  autocmd BufNewFile,BufRead,BufEnter *.wiki setfiletype vimwiki
  autocmd BufNewFile,BufRead,BufEnter *.ejs setfiletype html
augroup END

augroup _format_opts
  autocmd!
  autocmd FileType * set formatoptions-=cro fo+=j
augroup END

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                               plugin variables                               "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

source ~/.dotfiles/vim/vimrc/vars.vimrc

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                              if plug is loaded                               "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if !empty(glob('~/.vim/autoload/plug.vim')) && has('nvim')


lua << EOF
require "format".setup {
  -- lukas-reineke/format.nvim
  -- https://github.com/lukas-reineke/format.nvim
  -- :h format.txt

  -- npm install lua-fmt prettier -g
  -- pip install black, pylint, epdb, ipython
  -- autocmd BufWritePost * FormatWrite

  vim = {
    {
      cmd = {"luafmt -i 2 -w replace"},
      start_pattern = "^lua << EOF$",
      end_pattern = "^EOF$"
    }
  },
  lua = {
    {
      cmd = {
        function(file)
          return string.format("luafmt -i 2 -l %s -w replace %s", vim.bo.textwidth, file)
        end
      }
    }
  },
  python = {
    {
      cmd = {
        "black"
      }
    }
  },
  json = {
    {
      cmd = {"prettier -w --parser json"}
    }
  },
  typescript = {
    {
      cmd = {"prettier -w --parser typescript --single-quote"}
    }
  },
  yaml = {
    {
      cmd = {"prettier -w --parser yaml --single-quote --quote-props preserve"}
    }
  },
  vimwiki = {
    {
      cmd = {"prettier -w --parser babel"},
      start_pattern = "^{{{javascript$",
      end_pattern = "^}}}$",
      target = "current"
    },
    {
      cmd = {"luafmt -i 2 -w replace"},
      start_pattern = "^{{{lua$",
      end_pattern = "^}}}$",
      target = "current"
    },
    {
      cmd = {"black"},
      start_pattern = "^{{{python$",
      end_pattern = "^}}}$",
      target = "current"
    }
  },
  javascript = {
    {cmd = {"prettier -w --single-quote", "eslint --fix"}}
  },
  markdown = {
    {cmd = {"prettier -w"}},
    {
      cmd = {"luafmt -i 2 -w replace"},
      start_pattern = "^```lua$",
      end_pattern = "^```$",
      target = "current"
      -- current only format where cursor is
    }
  }
}
EOF

  nnoremap <silent><C-e> :call NerdTreeToggleFind()<CR>

  nnoremap <silent><C-p> :call FZFOpen(':GFiles')<CR>
  nnoremap <silent><leader>f :call FZFOpen(':Files')<CR>
  nnoremap <silent><leader>b :call FZFOpen(':Buffers')<CR>

  nmap <silent> [n <Plug>(ale_next_wrap)
  nmap <silent> ]n <Plug>(ale_previous_wrap)

  nmap p <Plug>(miniyank-autoput)
  nmap P <Plug>(miniyank-autoPut)
  " let g:miniyank_filename = $HOME.'/.tmp/miniyank-shared-ring'
  let g:miniyank_maxitems = 10

  nmap <silent> gr <Plug>(coc-references)
  " trigger completion, manually
  inoremap <silent><expr> <C-c> coc#refresh()

endif

if &diff
  " set cursorline
  map ] ]n
  map [ [n
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                core bindings                                 "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" find syntax group
map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
  \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
  \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

" disable c-z (bg)
nnoremap <c-z> <nop>
cnoremap <c-f> <nop>
nnoremap cp yap<S-}>p

" macros
nnoremap Q @q
xnoremap Q :'<,'>norm @q<cr>

" create list from visual select and normal mode -> single line
" xnoremap <C-l> :s/\v\s+$//ge<cr>gv :s/\v^(.+)$/"\1",/ge<cr>gvJ :noh<cr>

nnoremap <leader>ve :e $MYVIMRC<cr>
nnoremap <leader>vr :source $MYVIMRC<cr>

inoremap jk <Esc>:noh<cr><c-g>

" move around line wraps
nnoremap <expr> k v:count == 0 ? 'gk' : 'k'
nnoremap <expr> j v:count == 0 ? 'gj' : 'j'

nnoremap <silent><leader>t :silent !tmux send-keys -t 2 c-p Enter<cr>

nnoremap H ^
nnoremap L g_
vnoremap H ^
vnoremap L g_

nnoremap U <C-r>

cnoremap w!! w !sudo tee % > /dev/null
cnoremap %s %s/\v
cnoremap %g %g/\v
cnoremap %v %v/\v

" improved jumps w/marks (marks go to col ' `)
nnoremap ' `
nnoremap / ms/\v
xnoremap / ms/\v
nnoremap ? ms?\v
xnoremap ? ms?\v
nnoremap gg msgg<c-g>
nnoremap G msG<c-g>
nnoremap gd msgd
nnoremap * ms*
nnoremap # ms#

nmap V Vg_

let g:surround_no_mappings = 1
nmap S <Plug>YSurround
nmap s <Plug>Ysurround
nmap sw <Plug>YsurroundiW
nmap ys <Plug>Yssurround
nmap ds  <Plug>Dsurround
nmap cs  <Plug>Csurround
" nmap yS  <Plug>YSsurround
xmap s   <Plug>VSurround
" xmap gS  <Plug>VgSurround

nmap \wt <Plug>VimwikiTOC

" speed up common buffer operations
nnoremap <silent><leader>w :w<CR>
nnoremap <silent><Tab> :bnext<CR>
nnoremap <silent><S-Tab> :bprevious<CR>

nnoremap Y y$

" mark and return to mark after yank
vnoremap y mxy`x

" select visualy selected text for search
xnoremap <enter> y/\V<C-r>=escape(@",'/\')<CR><CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                   settings                                   "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" set cursorline
set autoindent
set autoread
set backspace=indent,eol,start
set cmdheight=2
set complete+=kspell complete-=i complete-=t
set completeopt-=preview
set diffopt=filler
set directory=~/.tmp
set display+=lastline
set encoding=utf-8 nobomb
set fileencoding=utf-8
set fillchars+=vert:│
set hidden
set history=999
set ignorecase
set incsearch
set laststatus=0
set magic
set nobackup nowritebackup noswapfile
set nojoinspaces
set list
set listchars=tab:→\ ,trail:·,nbsp:•
set noshowcmd
set novisualbell noerrorbells
set nowrap
set nrformats-=octal nrformats+=alpha
set nonumber numberwidth=2
set pastetoggle=<F2>
set ruler
set scrolloff=2
set shiftround shiftwidth=2
set shortmess+=c
set shortmess=atIoOsT
set showmode
set sidescrolloff=1
set smartcase smarttab
set spelllang=en_us
set splitbelow
set softtabstop=2 tabstop=2 textwidth=80 expandtab
set timeout timeoutlen=500 ttimeout ttimeoutlen=50
set undolevels=999
set updatetime=250
set wildignore+=*.o,*.obj,*.rbc,*.pyc,__pycache__/*,.git,.git/*
set winaltkeys=no
" set mouse=a

" performance settings
set lazyredraw
set matchtime=0
set nocursorcolumn
set redrawtime=10000
set ttyfast
" set re=1

set signcolumn=yes
" try
"   set signcolumn=number
" catch
"   set signcolumn=yes
" endtry

if has('nvim')
  set inccommand=nosplit
  " pmenu/transparency/max items
  set pumheight=10 pumblend=0
  tnoremap jk <C-\><C-n>
endif

" fixes issues with extra lines in EOF
set fileformats=unix,dos
set fixendofline
set foldlevel=1 foldmethod=indent foldnestmax=2 nofoldenable

" requires -> export DISPLAY=:0.0 on zshrc
if has('macunix')
  let clip_copy = 'pbcopy'
  let clip_paste = 'pbpaste'
else
  let clip_copy = 'xclip -sel clip -i'
  let clip_paste= 'xclip -out -selection clipboard'
endif

let g:clipboard = {}
let g:clipboard.name = 'limaClipboard'
let g:clipboard.cache_enabled = 1
let g:clipboard.copy = {}
let g:clipboard.copy['+'] = clip_copy
let g:clipboard.copy['*'] = 'tmux load-buffer -'
let g:clipboard.paste = {}
let g:clipboard.paste['+'] = clip_paste
let g:clipboard.paste['*'] = 'tmux save-buffer -'

set clipboard=unnamed
set clipboard+=unnamedplus

source ~/.dotfiles/vim/vimrc/aux.vimrc
" source ~/.dotfiles/vim/vimrc/python.vimrc
