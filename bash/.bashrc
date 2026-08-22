# ~/.bashrc
# vim: ft=bash

# If not running interactively, don't do anything
case $- in
*i*) ;;
*) return ;;
esac

# Disable flow control (Ctrl+S/Ctrl+Q)
stty -ixon 2>/dev/null

# --- CORE ENVIRONMENT VARIABLES ---
export GPG_TTY=$(tty 2>/dev/null || echo "/dev/tty")
export XDG_DATA_DIRS="/usr/local/share:/usr/share"
export GOPATH="$HOME/go"
export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"
export GOPRIVATE="github.com/ono7/utils,github.com/ono7/other"
export PASSWORD_STORE_CHARACTER_SET='[:alnum:]!&%^@{}[]()'
export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export CGO_ENABLED=0
export VIRTUAL_ENV_DISABLE_PROMPT=1
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES
export MANWIDTH=999
export PRE_COMMIT_COLOR=never
export TERM=xterm-256color
export CLICOLOR=1
export COLORTERM=truecolor

if command -v nvim >/dev/null 2>&1; then
  export EDITOR=nvim
else
  export EDITOR=vim
fi

# --- FAST PATH SETUP & OS DETECTION ---
if grep -q Microsoft /proc/version 2>/dev/null; then
  unset DISPLAY
  export PATH="$HOME/.fzf/bin:$HOME/.local/bin:$HOME/.deno/bin:$HOME/local/bin:$GOPATH/bin:$HOME/.rd/bin:$HOME/.luarocks/bin:$HOME/.npm-packages/bin:$HOME/local/node/bin:$HOME/local/yarn/bin:$HOME/bin:/usr/local/bin:/usr/local/share/dotnet:/usr/lib/cargo/bin:$HOME/.cargo/bin:$PATH"
elif [[ $OSTYPE == "darwin"* ]]; then
  export PATH="$HOME/.fzf/bin:$HOME/.local/bin:$HOME/.deno/bin:$HOME/local/bin:/opt/homebrew/sbin:/usr/local/sbin:/opt/homebrew/opt/grep/libexec/gnubin:/opt/homebrew/opt/gnu-sed/libexec/gnubin:$GOPATH/bin:$HOME/.rd/bin:$HOME/.luarocks/bin:/opt/homebrew/bin:$HOME/.npm-packages/bin:$HOME/local/node/bin:$HOME/local/yarn/bin:$HOME/bin:/usr/local/bin:/usr/lib/cargo/bin:$HOME/.cargo/bin:$PATH"
  export NEOVIDE_FRAME="transparent"
  ulimit -n 10240
else
  export PATH="$HOME/.npm-global/bin:$HOME/.fzf/bin:$HOME/.local/bin:$HOME/.deno/bin:$HOME/local/bin:$GOPATH/bin:$HOME/.rd/bin:$HOME/.luarocks/bin:$HOME/.npm-packages/bin:$HOME/local/node/bin:$HOME/local/yarn/bin:$HOME/bin:/usr/local/bin:/usr/local/share/dotnet:/usr/lib/cargo/bin:$HOME/.cargo/bin:$PATH"
  export NVD_BACKEND=direct
  export MOZ_ENABLE_WAYLAND=1
fi
export PATH="$HOME/.npm-global/bin:$HOME/.cache/lm-studio/bin:$PATH"

# Deduplicate PATH while preserving order
PATH=$(echo "$PATH" | awk -v RS=: -v ORS=: '!seen[$0]++ {print}' | sed 's/:$//')
export PATH

# --- SHELL OPTIONS & HISTORY ---
shopt -s histappend checkwinsize autocd globstar 2>/dev/null
HISTCONTROL=ignoreboth:erasedups
export HISTFILE="$HOME/.bash_history"
export HISTSIZE=100000
export HISTFILESIZE=100000
export HISTIGNORE="ls*:cat*:*AWS*:*SECRET*:*SSHPASS*"

# --- VI MODE & READLINE BINDINGS ---
set -o vi

# Navigation & Character Movement (Insert Mode)
bind -m vi-insert '"\C-f": forward-char'
bind -m vi-insert '"\C-b": backward-char'
bind -m vi-insert '"\C-n": next-history'
bind -m vi-insert '"\C-p": previous-history'
bind -m vi-insert '"\C-a": beginning-of-line'
bind -m vi-insert '"\C-e": end-of-line'
bind -m vi-insert '"\C-k": kill-line'
bind -m vi-insert '"\ef": forward-word'
bind -m vi-insert '"\eb": backward-word'

# Deletion & Execution
bind -m vi-insert '"\C-d": delete-char'
bind -m vi-insert '"\ed": kill-word'
bind -m vi-insert '"\e\C-?": backward-kill-word'
bind -m vi-insert '"\e\177": backward-kill-word'
bind -m vi-insert '"\C-o": accept-line'

# --- FZF THEME & COMMAND CONFIGURATION ---
export FZF_DEFAULT_OPTS='
--height 40%
--border=rounded
--color=bg:-1,bg+:#D5CFC4,fg:#38414D,fg+:#38414D
--color=hl:#B85C38,hl+:#B85C38,info:#996E14,prompt:#3B6EA8
--color=pointer:#C4434B,marker:#4A7A59,spinner:#2D7D8A,header:#3B6EA8
--color=border:#A9B3C1,separator:#E6E2DA,scrollbar:#7B8A9C'

if command -v fd &>/dev/null; then
  export FD_CMD='fd -I --type f --exclude ".git" --exclude "__pycache__" --exclude ".collections" --follow --hidden'
  export FZF_DEFAULT_COMMAND="$FD_CMD"
  export FZF_ALT_C_COMMAND='fd -I --type d --exclude .git --exclude "__pycache__" --follow --hidden'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

  _fzf_compgen_path() {
    fd -I --hidden --follow --exclude ".git" . "$1"
  }
  _fzf_compgen_dir() {
    fd -I --type d --hidden --follow --exclude ".git" . "$1"
  }
fi

# --- ALIASES ---

# Directory movement & navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias -- -='cd -'
alias f='cd $(fd --type d --hidden --exclude .git --exclude node_modules --exclude .cache --exclude .npm --exclude .venv | fzf)'

# Editors & Neovim
alias vim='nvim -n'
alias vi='nvim -n'
alias vio='/usr/bin/vi'
alias vil='vim -u ~/.vimrc_min'
alias vl='nvim -c "normal '\''0" -c "bn" -c "bd"'
alias n="/Applications/Neovide.app/Contents/MacOS/neovide --fork"
alias nv="/Applications/Neovide.app/Contents/MacOS/neovide"

# File listing (eza / ls)
if command -v eza >/dev/null 2>&1; then
  alias ls="eza --icons"
  alias ll="eza -lh --git --icons --group-directories-first"
  alias la="eza -lah --git --icons --group-directories-first"
  alias lt="eza --tree --level=2 --icons"
else
  alias ls="ls --color=auto"
  alias ll="ls -lah"
  alias la="ls -A"
  alias l="ls -CF"
fi

# Clipboard
if command -v pbcopy &>/dev/null; then
  alias c="pbcopy"
elif command -v wl-copy &>/dev/null; then
  alias c="wl-copy"
elif command -v xclip &>/dev/null; then
  alias c="xclip -selection clipboard"
fi

# General utilities
alias clear="clear -x"
alias less="less -R"
alias l="less -R"
alias xargs="xargs "
alias ts='date +%Y%m%d-%H%M%S'
alias tree="tree -a -I '*.pyc|__pycache__|venv|.git'"
alias rgl="rg -M 0"
alias grepl="grep --line-buffered"

# Git aliases
alias gs='git status --untracked-files=all --short'
alias gd='git diff'
alias gds='git diff --staged'
alias gf='git fetch --all'
alias gfh="git log --follow -p"
alias gr='git reflog'
alias gl='git log --color --graph --pretty=format:"%C(red)%h%Creset %s %C(dim white) ⌚%Creset %C(green)%cr%Creset %C(dim white)👤%Creset %C(cyan)%an%Creset %C(yellow)%d%Creset" --abbrev-commit --stat'
alias glb="git for-each-ref --sort=-committerdate refs/heads/ --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(color:green)(%(committerdate:relative))%(color:reset) %(contents:subject)'"
alias gwl='git worktree list'
alias gwr='git worktree remove'

# DevOps, Infrastructure & Tools
alias k='kubectl '
alias tf='terraform'
alias pb="ansible-playbook "
alias dc="docker compose "
alias dockerps='docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Image}}\t{{.State}}\t{{.Status}}"'
alias sshe='sshpass -e ssh '
alias ssh='TERM=xterm-256color ssh '

# Development & REPLs
alias god='go build -gcflags="all=-N -l"'
alias pret="prettier --parser "
alias aider="aider --no-auto-commits --dark-mode"
alias rlwrap='rlwrap --always-readline'
alias sqlite3='rlwrap sqlite3'
alias sqlite='rlwrap sqlite'

# --- FUNCTIONS ---

# Navigation & Sessions
_cdr() { cd "$(git rev-parse --show-toplevel 2>/dev/null || echo .)"; }
alias cdr=_cdr

cdf() {
  local file
  file=$(fd --type f | fzf --preview 'head -100 {}') && cd "$(dirname "$file")"
}

_d() {
  _cdr
  cd "$(fd -td -HI --exclude '.git' --exclude '__pycache__' . | fzf)"
}

fcd() {
  local dir
  dir=$(find "${1:-.}" -path '*/\.*' -prune -o -type d -print 2>/dev/null | fzf +m) && cd "$dir"
}

take() {
  [ -z "$1" ] && echo "Please provide an argument" && return 1
  local dir="$*"
  mkdir -p "${dir// /-}"
  cd "${dir// /-}" || return
}

vs() {
  if [[ -n "$NVIM" ]]; then
    nvim --clean --server "$NVIM" --remote-send '<C-\><C-n><C-w>p<C-/>:lua require("fzf-lua").files({cwd=[['"$PWD"']]})<CR>'
  else
    local file
    file="$(fd --type f -E .git | fzf --height 30% --reverse --border)"
    [[ -n "$file" ]] && nvim "$file"
  fi
}

vls() {
  local sessions_dir="$HOME/vim/sessions"
  local project_name
  project_name=$(basename "$PWD")
  local session_file="$sessions_dir/${project_name}.vim"
  if [[ -f "$session_file" ]]; then
    echo "Loading session for $project_name..."
    nvim -S "$session_file"
  else
    nvim -c "normal '0" -c "bn" -c "bd"
  fi
}

toggle() { fg %nvim; }

# Git & Dotfiles
fixgit() { git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"; }

dotp() {
  local my_dir=$PWD
  cd ~/.dotfiles || return
  git pull
  cd "$my_dir" || return
}

dotc() {
  local my_dir=$PWD
  cd "$HOME/.dotfiles" || return
  git pull
  git add .
  git commit
  git push
  cd "$my_dir" || return
}

gc() {
  git pull
  git add .
  git commit
  git push
}

gp() {
  printf '\n********* %s ********\n\n' "checking for updates"
  git pull
  printf '\n********* %s ********\n\n' "pushing pending changes"
  git push
  if [ -n "$PROJECT_ID" ]; then
    printf '\n********* %s ********\n\n' "updating project..."
    [ -f ~/aap-project-update.sh ] && bash -c ~/aap-project-update.sh
  fi
}

ga() {
  local mydir=$PWD
  local untracked_files
  untracked_files=$(git status --porcelain 2>/dev/null | grep '^??' | cut -c4-)
  if [ -n "$untracked_files" ]; then
    echo -e "Untracked files detected:\n$untracked_files\n"
    read -r -p "Do you want to add all untracked files? (y/n) " user_input
    if [[ $user_input =~ ^[Yy]$ ]]; then
      _cdr
      git add -A
      cd "$mydir" || return
      echo "Added all untracked files."
    fi
  fi

  if [ $# -eq 0 ]; then
    git add -p
  else
    git add "$@"
  fi
  git commit
}

gac() {
  if [ $# -eq 0 ]; then
    git add -p
  else
    git add "$@"
  fi
  git commit
}

gco() { git checkout "$@"; }

gb() { git checkout "$(git branch -a | fzf)"; }

gw() {
  if [ $# -eq 0 ]; then
    git worktree list
  else
    git worktree "$@"
  fi
}

gwa() { git worktree add "$@"; }

ginit() {
  [ -f ./config ] && git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*" && echo "fixed bare repo..." && return
  git init "$@"
  [ ! -f .gitignore ] && cp ~/.dotfiles/git/.gitignore .gitignore
  [ ! -f .pre-commit-config.yaml ] && cp ~/.dotfiles/templates/.pre-commit-config.yaml .pre-commit-config.yaml
  if command -v uvx >/dev/null 2>&1; then
    uvx pre-commit install -f
  elif command -v pre-commit >/dev/null 2>&1; then
    pre-commit install -f
  fi
}

mktag() {
  [ -z "$1" ] && echo "Please provide a tag name" && return 1
  git tag -a "$1" -m "$*"
  git push origin "$1"
}

rmtag() {
  [ -z "$1" ] && echo "Please provide a tag name" && return 1
  git tag -d "$1"
  git push --delete origin "$1"
}

release() {
  git for-each-ref --format="%(refname:short) (%(creatordate:short)): %(contents:subject)%0a%(contents:body)" refs/tags
}

gitlog() {
  git log --oneline --graph --decorate --simplify-by-decoration --color --date=local --pretty=format:'%C(auto) %h %d %C(reset)%s (%C(cyan)%ad %ae%C(reset))' "$@"
}

jira() {
  local my_dir=$PWD
  _cdr
  git add .
  local jira_id
  jira_id=$(git branch --show-current 2>/dev/null | grep -Eio "ntwk\-[0-9]{1,20}")
  local f
  f=$(git status --porcelain | cut -c4- | head -n 4)
  local more_changes
  more_changes=$(git status --porcelain | sed -n 5p)
  [ -n "$more_changes" ] && f="$f ..."
  if [ -z "$1" ]; then
    git commit -m "$jira_id updates to -> ${f//$'\n'/ }"
  else
    local comment="$*"
    git commit -m "$jira_id $comment -> ${f//$'\n'/ }"
  fi
  cd "$my_dir" || return
}

gitm() {
  $EDITOR $(git ls-files --modified --others --exclude-standard) "$@" || return
}

vimgd() {
  if [ $# -eq 2 ]; then
    local ref=${1}
    local gitrelfp=${2}
    local gitfullfp
    gitfullfp=$(git ls-files --full-name "$gitrelfp")
    local fname
    fname=$(basename "$gitrelfp")
    local tmpfname="/tmp/$(echo "$ref" | tr '/' '-')-$fname"
    git show "$ref:$gitfullfp" >"$tmpfname"
    vim -d "$tmpfname" "$gitrelfp" -c "setlocal nomodifiable"
  else
    echo "usage: vimgd <ref|branch|commit> <relative-file-path>"
  fi
}

# Python, Tooling & Automation
mkproject() {
  if [ -z "$1" ]; then
    echo "Usage: mkproject <project-name> [python-version]"
    return 1
  fi
  mkdir -p "$1" && cd "$1" || return 1
  cp -a ~/.dotfiles/templates/. .
  if [ -n "$2" ]; then
    uv init --python "$2"
    uv venv --python "$2"
  fi
  ginit
  direnv allow 2>/dev/null
}

va() {
  deactivate 2>/dev/null || true
  if [[ -d .venv ]]; then
    source .venv/bin/activate 2>/dev/null
  elif [[ -d $(git rev-parse --show-toplevel 2>/dev/null)/.venv ]]; then
    source "$(git rev-parse --show-toplevel)/.venv/bin/activate"
  else
    echo "no python env found.."
    return 1
  fi
  echo "$(which python3)"
}

vd() {
  deactivate 2>/dev/null && echo ".venv deactivated.."
}

vc() {
  deactivate 2>/dev/null
  echo "use: vc --python 3.11.9"
  uv venv --seed --python-preference managed "$@" && va
}

poetry_shell() {
  deactivate 2>/dev/null
  . "$(dirname "$(poetry run which python)")/activate"
  which python
}

uv_poetry_install() {
  uv pip install --no-deps -r <(POETRY_WARNINGS_EXPORT=false poetry export --without-hashes --with dev -f requirements.txt)
  poetry install --only-root
}

mkrole() {
  local dir1="$*"
  local mydir="roles/${dir1// /_}"
  if [ -d "$mydir" ]; then
    echo "role $mydir already exists :("
    return 1
  fi
  echo "creating ansible role -> $mydir"
  for d in defaults files handlers meta tasks templates tests vars; do
    mkdir -p "$mydir/$d"
    echo "created $mydir/$d (dir)"
  done
  for f in defaults handlers tasks meta vars; do
    if [ ! -f "$mydir/$f/main.yml" ]; then
      echo '---' >>"$mydir/$f/main.yml"
      echo "created $mydir/$f/main.yml (file)"
    fi
  done
  echo "done!"
}

golinux() {
  [ -z "$1" ] && printf "builds go binary for linux\nUse: golinux -o app main.go\n" && return
  env GOOS=linux GOARCH=amd64 go build "$@"
}

runner() {
  if ! command -v nodemon &>/dev/null; then
    npm install -g nodemon
  fi
  if [ $# -lt 2 ]; then
    echo "Examples:"
    echo "runner go run main.go"
    echo "runner python -m flask.run"
    return
  fi
  nodemon --exec "$@" --signal SIGTERM
}

# System, Credentials & Utils
ta() {
  if ! command -v tmux &>/dev/null; then
    echo "Error: tmux is not installed."
    return 1
  fi
  local SESSION_NAME="${1:-develop}"
  if [ -n "$TMUX" ]; then
    if [ -n "$1" ]; then
      tmux detach-client -E "tmux new-session -A -s '$SESSION_NAME'"
    else
      return 0
    fi
  else
    tmux new-session -A -s "$SESSION_NAME"
  fi
}

tmux_log() {
  tmux capture-pane -S - \; save-buffer ~/tmux_log.txt
}

wrap() {
  local port="${1:-4444}"
  socat READLINE,history="$HOME/.pdb_history" "TCP:127.0.0.1:$port"
}

ct() {
  local wd=$PWD
  _cdr
  ctags -R --exclude="@$HOME/.ctagsignore"
  cd "$wd" || return
}

a() {
  awk -v field="${1:-1}" '{print $field}'
}

mem() {
  [ -z "$1" ] && echo "shows memory used by PID, enter a PID" && return
  ps -o rss= -p "$1" | awk '{ hr=$1/1024; printf "%13.2f Mb\n",hr }' | tr -d ' '
}

jsondiff() {
  delta <(jq --sort-keys . "$1") <(jq --sort-keys . "$2")
}

brewit() {
  brew update &&
    brew upgrade &&
    brew autoremove &&
    brew cleanup -s &&
    brew doctor
}

extract() {
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

fpass() {
  local password edit=0 clipboard=0
  while getopts "ec" opt; do
    case $opt in
    e) edit=1 ;;
    c) clipboard=1 ;;
    \?)
      echo "Usage: fpass [-e] [-c]" >&2
      return 1
      ;;
    esac
  done
  password=$(find ~/.password-store -name "*.gpg" 2>/dev/null |
    sed -E 's,(.*)\.password-store/(.*)\.gpg,\2,' |
    fzf +m)
  if [[ -n "$password" ]]; then
    if [[ $edit -eq 1 ]]; then
      pass edit "$password"
    elif [[ $clipboard -eq 1 ]]; then
      pass -c "$password"
    else
      SSHPASS=$(pass show "$password" | head -n1)
      export SSHPASS
    fi
  fi
}

gpg_delete_key() {
  [ -z "$1" ] && echo "no key provided" && return
  echo "Deleting secret key..."
  gpg --delete-secret-key "$1"
  echo "Deleting public key..."
  gpg --delete-key "$1"
}

gpg_backup() {
  gpg --list-keys --keyid-format SHORT
  [ -z "$1" ] && echo "provide a key.." && return
  gpg --export-secret-keys --armor "${1}" >private.key
  gpg --export --armor "${1}" >public.key
  echo "gpg --import private.key"
  echo "gpg --import public.key"
  echo "# set trust level"
  echo "gpg --edit-key YOUR_KEY_ID"
}

mycolors() {
  for i in {0..15}; do
    echo "$(tput setaf "$i")Color $i: ████████$(tput sgr0) ($(tput setaf "$i")■■■■■■■■$(tput sgr0))"
  done
}

# --- TOOL INTEGRATIONS & PROMPT ---
# FZF shell integration
if command -v fzf &>/dev/null; then
  eval "$(fzf --bash 2>/dev/null)" || [ -f ~/.fzf.bash ] && source ~/.fzf.bash
fi

# Modern CLI tools
command -v zoxide &>/dev/null && eval "$(zoxide init bash)"
command -v direnv &>/dev/null && eval "$(direnv hook bash)"
command -v starship &>/dev/null && eval "$(starship init bash)"

# --- TOOL INTEGRATIONS & PROMPT ---
if command -v fzf &>/dev/null; then
  eval "$(fzf --bash 2>/dev/null)" || [ -f ~/.fzf.bash ] && source ~/.fzf.bash

  # Remove Ctrl+T bindings across all keymaps (matches zsh: bindkey -r '^T')
  bind -r '\C-t' 2>/dev/null
  bind -m vi-insert -r '\C-t' 2>/dev/null
  bind -m vi-command -r '\C-t' 2>/dev/null
  bind -m emacs -r '\C-t' 2>/dev/null

  # Bind Ctrl+Space (Ctrl+@) to FZF history if desired (matches zsh: bindkey "^@" fzf-history-widget)
  bind -m vi-insert '"\C-@": "\C-r"' 2>/dev/null
  bind -m emacs '"\C-@": "\C-r"' 2>/dev/null
fi
