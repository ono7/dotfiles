export ZK_NOTEBOOK_DIR="$HOME/notes"
alias f='fd -tf'
alias l='less -R '
alias m='more '
alias cdr='cd "$(git rev-parse --show-toplevel 2>/dev/null)"  &>/dev/null'
alias pret="prettier --parser "
alias vil="/usr/bin/vi"
alias aider="aider --no-auto-commits --dark-mode"
alias dc="docker compose "
alias nv="/Applications/Neovide.app/Contents/MacOS/neovide"

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
  printf '\n********* %s ********\n\n' "pushing changes"
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

alias gd='git diff '
alias gds='git diff --staged'
alias gc='git commit '

# shows tags for release reports
release () {
  git for-each-ref --format="%(refname:short) (%(creatordate:short)): %(contents:subject)%0a%(contents:body)" refs/tags
}

gco () {
  git switch -c "$1" || git switch "$1"
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
}

if [ -f "$HOME/.cargo/env" ]; then
  . "$HOME/.cargo/env"
fi
