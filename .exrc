let s:cpo_save=&cpo
set cpo&vim
inoremap <C-G>S <Plug>(nvim-surround-insert-line)
inoremap <C-G>s <Plug>(nvim-surround-insert)
cnoremap <C-S-V> +
cnoremap <C-S-V> +
inoremap <C-S-V> +
inoremap <C-S-V> +
inoremap <Plug>(snippy-previous) <Cmd>lua require "snippy".previous()
inoremap <Plug>(snippy-next) <Cmd>lua require "snippy".next()
inoremap <Plug>(snippy-expand) <Cmd>lua require "snippy".expand()
inoremap <Plug>(snippy-expand-or-advance) <Cmd>lua require "snippy".expand_or_advance()
imap <Plug>(snippy-expand-or-next) <Plug>(snippy-expand-or-advance)
cnoremap <C-BS> 
inoremap <M-o> o
inoremap <M-O> O
inoremap <C-X> :call InsertSwapMark()
inoremap <C-Space> :call InsertSetMark()
inoremap <M-l> guea
inoremap <M-u> gUea
inoremap <C-Y> up
inoremap <M-k> ud}
inoremap <C-K> uD
inoremap <M-d> udw
inoremap <M-BS> u
inoremap <C-H> u<BS>
inoremap <C-D> u<Del>
inoremap <M-}> }
inoremap <M-{> {
inoremap <M-b> <S-Left>
inoremap <M-f> e<Right>
inoremap <C-E> <End>
inoremap <C-A> _
inoremap <C-F> <Right>
inoremap <C-B> <Left>
inoremap <C-N> <Down>
inoremap <C-P> <Up>
inoremap <C-R> ?\v
inoremap <silent> <C-,> :call DuplicateAndMark()
inoremap <C-/> 
inoremap <M->> uG$
inoremap <M-lt> ugg^
inoremap <C-BS> u
cnoremap <C-L> <Right>
cnoremap <C-E> <End>
cnoremap <C-B> <Left>
cnoremap <C-A> <Home>
inoremap <M-C-U> <Nop>
inoremap <M-C-U> <Nop>
inoremap <M-e> <Nop>
inoremap <C-S> /\v
inoremap <C-W> u
inoremap <C-U> u
inoremap <D-q> <Nop>
nnoremap  x
nnoremap  <End>
nnoremap  k
vnoremap <silent>  y/\V=escape(@",'/\')
nnoremap  :Rg 
nnoremap <silent>  <Cmd>T
tnoremap <silent>  <Cmd>T
vnoremap q c
nnoremap  c
nnoremap q c
nmap  d
tnoremap <silent>  
nnoremap  pl <Cmd>L
nnoremap  pr <Cmd>ProjectRemove
nnoremap  pa <Cmd>ProjectAdd
nnoremap  pp <Cmd>ProjectPick
nnoremap <silent>  z :ZoxideCD
xmap  d <Plug>(snippy-cut-text)
nnoremap  cp <Cmd>let @+ = expand("%:p")
nnoremap <silent>  n <Cmd>e ~/notes.md
nnoremap <silent>  d :call SmartClose()
nnoremap  td <Cmd>e ~/todo.md
nnoremap  x <Cmd>x
nnoremap  a ggVG
nnoremap <silent>    <Cmd>noh
nnoremap   <Nop>
xnoremap & :'<,'>s/\%V\v
nnoremap & :&&
xnoremap ' :call WrapSelection("'", "'")
nnoremap 't `T
nnoremap 's `S
nnoremap 'r `R
nnoremap 'b `B
nnoremap 'a `A
xnoremap ( :call WrapSelection('(', ')')
xnoremap . :normal! .
nnoremap ; :
vnoremap < <gv
vnoremap > >gv
xnoremap <silent> <expr> @ mode() ==# 'V' ? ':normal! @'.getcharstr().'' : '@'
nnoremap D d$
xnoremap H <gv
vnoremap J :m '>+1gv=gv
vnoremap K :m '<-2gv=gv
xnoremap L >gv
xnoremap Q <Cmd>norm @q
nmap Q <Nop>
smap Q <Nop>
omap Q <Nop>
xnoremap S <Plug>(nvim-surround-visual)
nnoremap U 
nnoremap Y yg_
nnoremap ZQ <Nop>
nnoremap ZZ <Nop>
xnoremap [ :call WrapSelection('[', ']')
xnoremap ` :call WrapSelection('`', '`')
nnoremap cS <Plug>(nvim-surround-change-line)
nnoremap cs <Plug>(nvim-surround-change)
nnoremap cp yap<S-}>p
nnoremap cW ciW
nnoremap cw ciw
nnoremap ds <Plug>(nvim-surround-delete)
nnoremap dW diW
xnoremap gS <Plug>(nvim-surround-visual-line)
nnoremap <silent> gz :call ToggleFolding()
nnoremap gy `[v`]
nnoremap <silent> gt :GoTagAdd
nnoremap gm :Git add % | Git commit % -m "=expand('%:t'): "<Left>
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'
nnoremap j gj
nnoremap k gk
nnoremap <silent> mt :call SetGlobalMark('T')
nnoremap <silent> ms :call SetGlobalMark('S')
nnoremap <silent> mr :call SetGlobalMark('R')
nnoremap <silent> mb :call SetGlobalMark('B')
nnoremap <silent> ma :call SetGlobalMark('A')
xnoremap p "_dP
nnoremap vW viW
nnoremap vp vip
nnoremap vw viw
nnoremap ySS <Plug>(nvim-surround-normal-cur-line)
nnoremap yS <Plug>(nvim-surround-normal-line)
nnoremap ys <Plug>(nvim-surround-normal-cur)
xnoremap <silent> y ygv
xnoremap <C-9> 9gt
tnoremap <C-9> 9gt
xnoremap <C-8> 8gt
tnoremap <C-8> 8gt
xnoremap <C-7> 7gt
tnoremap <C-7> 7gt
xnoremap <C-6> 6gt
tnoremap <C-6> 6gt
xnoremap <C-5> 5gt
tnoremap <C-5> 5gt
xnoremap <C-4> 4gt
tnoremap <C-4> 4gt
xnoremap <C-3> 3gt
tnoremap <C-3> 3gt
xnoremap <C-2> 2gt
tnoremap <C-2> 2gt
xnoremap <C-1> 1gt
tnoremap <C-1> 1gt
nnoremap <C-K> k
vnoremap <C-S-V> "+p
vnoremap <C-S-V> "+p
nnoremap <C-S-V> "+p
nnoremap <C-S-V> "+p
tnoremap <D-V> "+pi
tnoremap <C-S-V> "+pi
tnoremap <C-S-V> "+pi
nnoremap <M-Bslash> <Cmd>Oil
xnoremap <Plug>(snippy-cut-text) <Cmd>call snippy#cut_text(mode(), v:true)
nnoremap <Plug>(snippy-cut-text) <Cmd>set operatorfunc=snippy#cut_textg@
snoremap <Plug>(snippy-previous) <Cmd>lua require "snippy".previous()
snoremap <Plug>(snippy-next) <Cmd>lua require "snippy".next()
snoremap <Plug>(snippy-expand-or-advance) <Cmd>lua require "snippy".expand_or_advance()
smap <Plug>(snippy-expand-or-next) <Plug>(snippy-expand-or-advance)
nnoremap <M-j> <Cmd>cnext
nnoremap <M-k> <Cmd>cprev
nnoremap <silent> <C-T> <Cmd>T
tnoremap <silent> <D-r> 
tnoremap <silent> <D-n> 
tnoremap <silent> <D-p> 
tnoremap <silent> <D-c> 
tnoremap <silent> <D-d> 
tnoremap <silent> <D-e> 
tnoremap <silent> <C-T> <Cmd>T
tnoremap <silent> <C-X> 
tnoremap <C-BS> 
tnoremap <M-BS> 
nnoremap <D-o> 
nnoremap <D-i> 	
nnoremap <C-9> 9gt
nnoremap <C-8> 8gt
nnoremap <C-7> 7gt
nnoremap <C-6> 6gt
nnoremap <C-5> 5gt
nnoremap <C-4> 4gt
nnoremap <C-3> 3gt
nnoremap <C-2> 2gt
nnoremap <C-1> 1gt
nnoremap <M-d> dw
nnoremap <C-D> x
nnoremap <M-[> <Cmd>tabprev
nnoremap <M-]> <Cmd>tabnext
nnoremap <M-t> <Cmd>tabnew
vnoremap <C-W>q c
nnoremap <C-W><C-Q> c
nnoremap <C-W>q c
nnoremap <C-S> :Rg 
tnoremap <M-f> f
tnoremap <M-b> b
nnoremap <silent> <C-,> <Cmd>call DuplicateAndMark()
nnoremap <C-E> <End>
nnoremap <M-e> <Nop>
nmap <C-W><C-D> d
tnoremap <D-q> <Nop>
vnoremap <D-q> <Nop>
nnoremap <D-q> <Nop>
inoremap  _
cnoremap  <Home>
inoremap  <Left>
cnoremap  <Left>
inoremap  u<Del>
inoremap  <End>
cnoremap  <End>
inoremap  <Right>
inoremap S <Plug>(nvim-surround-insert-line)
inoremap s <Plug>(nvim-surround-insert)
inoremap  u<BS>
inoremap  uD
cnoremap  <Right>
inoremap  <Down>
inoremap  <Up>
inoremap  ?\v
inoremap  /\v
inoremap  u
inoremap  u
inoremap  :call InsertSwapMark()
inoremap  up
cabbr q! qa!
cabbr qq qa!
let &cpo=s:cpo_save
unlet s:cpo_save
set clipboard=unnamedplus
set complete=.,w,b
set completeopt=menuone,fuzzy
set confirm
set diffopt=vertical,filler,context:5,internal,algorithm:histogram,indent-heuristic,linematch:60,closeoff
set directory=~/.tmp
set errorfile=/var/folders/lx/vnj67y653fd0v8pln7qg_9940000gn/T/nvim.jlima/adq1nV/12
set expandtab
set fileformats=unix
set fillchars=diff:â•±,eob:\ ,fold:\ ,foldclose:â–¶,foldopen:ï‘¼,msgsep:â€¾,stl:\ ,vert:â”‚
set foldlevelstart=99
set formatoptions=qlj
set grepformat=%f:%l:%c:%m
set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case\ --pcre2
set guicursor=a:block-blinkwait0-blinkoff400-blinkon250-Cursor/Cursor
set history=1000
set nohlsearch
set ignorecase
set isfname=#,$,%,+,,,-,.,/,48-57,=,@,_,~,@-@
set linespace=10
set listchars=tab:\ \ ,trail:â€¢,nbsp:Â·,conceal:\ 
set noloadplugins
set matchtime=0
set maxmempattern=2000
set mouse=a
set mousemodel=extend
set nrformats=bin,hex,alpha
set packpath=~/.local/share/nvim/runtime
set path=.,**
set pumheight=5
set quickfixtextfunc=v:lua.require'quicker.display'.quickfixtextfunc
set runtimepath=~/.config/nvim,~/.local/share/nvim/lazy/lazy.nvim,~/.local/share/nvim/lazy/conform.nvim,~/.local/share/nvim/lazy/dressing.nvim,~/.local/share/nvim/lazy/nvim-surround,~/.local/share/nvim/lazy/tiny-inline-diagnostic.nvim,~/.local/share/nvim/lazy/diffview.nvim,~/.local/share/nvim/lazy/oil.nvim,~/.local/share/nvim/lazy/nvim-tmux-navigation,~/.local/share/nvim/lazy/quicker.nvim,~/.local/share/nvim/lazy/vim-fugitive,~/.local/share/nvim/lazy/vim-dispatch,~/.local/share/nvim/lazy/mason-tool-installer.nvim,~/.local/share/nvim/lazy/mason.nvim,~/.local/share/nvim/lazy/mason-lspconfig.nvim,~/.local/share/nvim/lazy/nvim-web-devicons,~/.local/share/nvim/lazy/tabby.nvim,~/.local/share/nvim/lazy/lspkind.nvim,~/.local/share/nvim/lazy/fidget.nvim,~/.local/share/nvim/lazy/gitsigns.nvim,~/.local/share/nvim/lazy/mini.icons,~/.local/share/nvim/lazy/fzf-lua,~/.local/share/nvim/lazy/nvim-treesitter,~/.local/share/nvim/lazy/nvim-snippy,~/.local/share/nvim/lazy/neovim-ayu,~/.local/share/nvim/runtime,~/.local/lib/nvim,~/.local/share/nvim/lazy/mason-lspconfig.nvim/after,~/.config/nvim/after,~/.local/state/nvim/lazy/readme
set scrollback=1000
set scrolloff=5
set sessionoptions=blank,buffers,curdir,folds,help,tabpages,winsize
set shada='100,<50,s10,:1000,/1000,h,r/COMMIT_EDITMSG,r/git-rebase-todo,!
set shell=zsh
set shiftwidth=2
set shortmess=aoOstTWICcF
set showbreak=â†ª\ 
set noshowcmd
set sidescroll=3
set sidescrolloff=5
set smartcase
set smartindent
set softtabstop=2
set spelllang=en_us
set spellsuggest=best,9
set splitkeep=screen
set splitright
set statusline=\ %{expand('%:h:t')}/%t%m%r%h%=\ (%l,%c)\ %=\ %p%%\ 
set noswapfile
set synmaxcol=200
set tabline=%!TabbyRenderTabline()
set tabstop=2
set tags=./tags,tags;~
set termguicolors
set textwidth=80
set notimeout
set timeoutlen=300
set title
set undodir=~/.undo
set undofile
set updatetime=400
set wildignore=*/.git/*,*/.venv/*,*/__pycache__/*,*/.tox/*,*/.collections/*,*/venv/*,*.pyc
set window=26
" vim: set ft=vim :
