export ZK_NOTEBOOK_DIR="$HOME/notes"
# alias f='fd -tf'
alias l='less -R '
alias m='more '
alias cdr='cd "$(git rev-parse --show-toplevel 2>/dev/null)"  &>/dev/null'
alias pret="prettier --parser "
alias vil="/usr/bin/vi"
alias aider="aider --no-auto-commits --dark-mode"
alias dc="docker compose "
alias nv="/Applications/Neovide.app/Contents/MacOS/neovide"
alias f='cd $(fd --type d --hidden --exclude .git --exclude node_module --exclude .cache --exclude .npm --exclude .mozilla --exclude .meteor --exclude .venv | fzf)'
alias sshe='sshpass -e ssh '

golinux () {
  [ -z $1 ] && echo "builds go binary for linux\nUse: golinux -o app main.go" && return
  env GOOS=linux GOARCH=amd64 go build $@
}

[ -f "/etc/os-release" ] && cat /etc/os-release | grep "buntu" &>/dev/null && export skip_global_compinit=1

mem () {
  [ -z "$1" ] && echo "shows memory used by PID, enter a PID" && return
  ps -o rss= -p "$1" | awk '{ hr=$1/1024; printf "%13.2f Mb\n",hr }' | tr -d ' ';
}

jsondiff () {
  delta <(jq --sort-keys . $1) <(jq --sort-keys . $2)
}

brewit () {
  brew update &&
    brew upgrade &&
    brew autoremove &&
    brew cleanup -s &&
    brew doctor
}

extract () {
  if [ -f "$1" ]; then
    case "$1" in
    *.tar.bz2) tar vxjf "$1" ;;
    *.tar.gz) tar vxzf "$1" ;;
    *.bz2) bunzip2 "$1" ;;
    *.rar) unrar x "$1" ;;
    *.gz) gunzip "$1" ;;
    *.tar) tar vxf "$1" ;;
    *.tbz2) tar vxjf "$1" ;;
    *.tgz) tar vxzf "$1" ;;
    *.zip) unzip "$1" ;;
    *.Z) uncompress "$1" ;;
    *.7z) 7z x "$1" ;;
    *) echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

gp () {
  printf '\n********* %s ********\n\n' "checking for updates"
  git pull
  printf '\n********* %s ********\n\n' "pushing pending changes"
  git push
  if [ ! -z $PROJECT_ID ]; then
    printf '\n********* %s ********\n\n' "upgating project..."
    [ -f ~/aap-project-update.sh ] && bash -c ~/aap-project-update.sh
  fi
}


ga () {
  # Check for untracked files
  mydir=$PWD
  untracked_files=$(git status --porcelain | grep '^??' | cut -c4-)
  if [ -z "$untracked_files" ]; then
    echo "No new untracked files."
  else
    echo "Untracked files detected."
    echo " "
    echo "$untracked_files"
    echo " "
    echo "Do you want to add all untracked files? (y/n)"
    read -r user_input
    if [[ $user_input =~ ^[Yy]$ ]]; then
      cdr
      git add -A
      cd $mydir
      echo "Added all untracked files."
    fi
  fi

  # Proceed with the rest of the function
  if [ "$#" -eq 0 ]; then
    git add -p
  else
    git add "$@"
  fi
  git commit
}

gap () {
  ga "$@"
  gp
}

gac () {
  if [ "$#" -eq 0 ]; then
    git add -p
  else
    git add "$@"
  fi
  git commit
}


dotp () {
    my_dir=$PWD
    cd ~/.dotfiles
    git pull
    cd $my_dir
}

dotc () {
    my_dir=$PWD
    cd ~/.dotfiles
    git pull
    git add .
    # f=$(git status --porcelain | cut -c4- | head -n 4)
    # more_changes=$(git status --porcelain | sed -n 5p)
    # [ -n "$more_changes" ] && f="$f ..."
    # git commit "-m updates -> ${f//$'\n'/ }"
    # git commit
    git commit
    git push
    cd $my_dir
}

gc () {
    git pull
    git add .
    git commit
    git push
}
# alias gc='git commit '

alias gd='git diff '
alias gds='git diff --staged'

# shows tags for release reports
release () {
  git for-each-ref --format="%(refname:short) (%(creatordate:short)): %(contents:subject)%0a%(contents:body)" refs/tags
}

gco () {
  git checkout $@
}

alias gf='git fetch --all'
alias afk="open /System/Library/CoreServices/ScreenSaverEngine.app"

# deletes merged branches
# alias gdm="git branch --merged | grep -Pv '(^\*|master|main)' | xargs git branch -d"
alias gdm="git branch --merged | grep -Pv '(^\*|master|main|production|development)' | sed 's/\+//' | xargs echo"
alias gdmr="git branch --merged | grep -Pv '(^\*|master|main|production|development)' | sed 's/\+//' | xargs git branch -d"
alias gitrm="git fetch -p && git branch -vv | grep ': gone]' | a | xargs git branch -D"
alias gdmrr="git branch --merged | grep -Pv '(^\*|master|main|production|development)' | sed 's/\+//' | xargs git worktree remove"

# git follow a file history gfh nvim/init.lua
alias gfh="git log --follow -p"

# view logs with changes with gl -p
# alias gl="git log --graph --abbrev=10 --pretty=format:'%Cred%h%Creset%Cgreen(%ar)%C(bold blue)<%an>%Creset -%C(yellow)%d%Creset %s ' --abbrev-commit"
alias gl="git log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias glb="git for-each-ref --sort=-committerdate refs/heads/ --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(color:green)(%(committerdate:relative))%(color:reset) %(contents:subject)'"
alias gpu='git pull'
alias gr='git reflog '
alias gs='git status '

gw () {
  if [ $# -eq 0 ]; then  # Check if no arguments were provided
    git worktree list
  else
    git worktree "$@"
  fi
}

gwa () {
  git worktree add "$@"
}

gwr () {
  git worktree remove "$@"
}

alias gwl='git worktree list'
alias gwr='git worktree remove '

tmux_log () {
  tmux capture-pane -S - \; save-buffer ~/tmux_log.txt
}

alias p='podman'

a () {
  # super useful shortcut echo "this is a test" | a 2 -> "is"
  awk -v field="${1:-1}" '{print $field}'
}

# open other modified files in a repo
gitm () {
  $EDITOR $(git ls-files --modified --others --exclude-standard) $@ || return
}

cdt () {
  # will display the 2nd and 3rd colums of text, but allow fzf to select the first to pass to the cd command
  selected_dir=$(git worktree list | fzf --select-1 --layout=reverse --info=inline --with-nth=2,3)
  if [ -n "$selected_dir" ]; then
    cd $(echo $selected_dir | a)
  fi
}

banner () {
  title="$@"
  COLUMNS=$(tput cols)
  title_size=${#title}
  span=$(( (COLUMNS + title_size) / 2 ))
  printf "%${COLUMNS}s\n" | tr " " "*"
  printf "%${span}s\n" "$title"
  printf "%${COLUMNS}s\n" | tr " " "*"
}


gpg_delete_key () {
    [ -z $1 ] && echo "no key provided" && return
    echo "Deleting secret key..."
    gpg --delete-secret-key "$1"

    echo "Deleting public key..."
    gpg --delete-key "$1"
}

gpg_backup () {
  gpg --list-keys --keyid-format SHORT
  [ -z $1 ] && echo "provide a key.." && return
  gpg --export-secret-keys --armor "${1}" > private.key
  gpg --export --armor "${1}" > public.key

  echo "gpg --import private.key"
  echo "gpg --import public.key"
  echo "# set trust level"
  echo "gpg --edit-key YOUR_KEY_ID"
}

if [ -f "$HOME/.cargo/env" ]; then
  . "$HOME/.cargo/env"
fi


## remote vim setup ##
vims() {
cat << 'SETUP_END'
unset HISTFILE
set -o vi
stty -ixon

if [[ -n "$ZSH_VERSION" ]]; then
    setopt NO_HIST_SAVE
    setopt NO_HIST_STORE
else
    set +o history
fi

alias vim='vim -u /tmp/rc$$'
alias vi='vim -u /tmp/rc$$'
  cat > /tmp/rc$$ << 'EOF'
set nocompatible
filetype plugin indent on
syntax off

set viminfo='30,<1000,s100,:100,/100,h,r/COMMIT_EDITMSG$$

set t_Co=8
let &fcs='eob: '
set path+=**
set autoread
set hidden
set tabstop=2
set sw=2
set wildmenu
set wildmode=longest:full,full
set wildignorecase
set wildignore+=**/__pycache__/**,**/venv/**,**/.venv/**,**/.git/**
set ignorecase
set incsearch
set laststatus=1
set display+=lastline
set encoding=utf-8
set nohlsearch
set magic
set noshowcmd
set nowrap
set number
set completeopt=longest
set pumheight=10
set notitle
set relativenumber
set shortmess=atcIoOsT
set timeout ttimeout
set fillchars+=vert:│
set fillchars+=stl:─
set fillchars+=diff:╱
" set statusline=%{repeat('─',winwidth('.'))}
set splitbelow
set splitright
set fileformats=unix
set autoindent
set guicursor=
set tags=./tags,tags;~
set backspace=indent,eol,start
set nobackup nowritebackup noswapfile
set nojoinspaces

set undolevels=999
if !isdirectory($HOME."/.vim/undo")
    call mkdir($HOME."/.vim/undo", "p", 0700)
endif
set undodir=~/.vim/undo
set undofile

cnoreabbrev qq qa!

nnoremap > mz`[V`]>`z
nnoremap < mz`[V`]<`z

xnoremap H <gv
xnoremap L >gv

nnoremap <c-j> <C-W><C-J>
nnoremap <c-k> <C-W><C-K>
nnoremap <c-l> <C-W><C-L>
nnoremap <c-h> <C-W><C-H>

nnoremap v <c-v>
inoremap <C-c> <Esc>

inoremap <C-a> <Home>
inoremap <C-e> <End>

vnoremap y ygv<Esc>
nnoremap p p=`]
nnoremap Y y$
nnoremap D d$
nnoremap cp yap<S-}>p
nnoremap U <c-r>
nnoremap <c-e> g_

nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'
vnoremap <enter> y/\V<C-r>=escape(@",'/\')<CR><CR>

cnoremap <C-A> <Home>
cnoremap <C-h> <Left>
cnoremap <C-l> <Right>

if has('unnamedplus')
  set clipboard=unnamedplus
else
  set clipboard=unnamed
endif

augroup _quickfix
  autocmd!
  autocmd FileType qf nnoremap <buffer> <CR> <CR>
  autocmd QuickFixCmdPost [^l]* cwindow 6
  autocmd QuickFixCmdPost    l* lwindow 6
augroup END

fun! <SID>TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$$//e
    call winrestview(l:save)
endfun

augroup _write
  autocmd!
  autocmd BufWritePre * silent! :retab!
  autocmd BufWritePre * call <SID>TrimWhitespace()
augroup END

hi! clear Error
hi! clear ModeMsg
hi! Comment ctermfg=8 ctermbg=NONE guifg=DarkGrey guibg=NONE
hi! link LineNr Comment
hi! link SpecialKey Comment
hi! link VertSplit Comment
hi! clear StatusLine
hi! clear StatusLineNC
hi! Visual guibg=#243d61
hi! Normal guibg=NONE ctermbg=NONE
EOF
trap 'rm -f /tmp/rc$$; rm -rf ~/.vim/undo' EXIT
for i in {1..2}; do fc -R /dev/null; done

if [[ -n "$ZSH_VERSION" ]]; then
    # export HISTFILE=~/.zsh_history
    fc -P
else
    # export HISTFILE=~/.bash_history
    set -o history
fi

echo "Vim setup complete! Vi mode enabled."
SETUP_END
for i in {1..2}; do fc -R /dev/null; done
}
