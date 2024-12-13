# Uncomment next line to start profiling
# zmodload zsh/zprof

# export GPG_TTY=$(tty)
export GPG_TTY="/dev/tty"

############## Essential environment variables ##############

# export COLORTERM=truecolor
export GOPATH=$HOME/go
export RIPGREP_CONFIG_PATH=$HOME/.ripgreprc
export GOPRIVATE=github.com/ono7/utils,github.com/ono7/other
export PATH="$HOME/.fzf/bin:$HOME/.local/bin:$HOME/.deno/bin:$HOME/local/bin:/opt/homebrew/sbin:/usr/local/sbin:/snap/bin:/opt/homebrew/opt/grep/libexec/gnubin:/opt/homebrew/opt/gnu-sed/libexec/gnubin:$GOPATH/bin:$HOME/.rd/bin:$HOME/.luarocks/bin:/opt/homebrew/bin:$HOME/.npm-packages/bin:$HOME/local/node/bin:$HOME/local/yarn/bin:$HOME/bin:/usr/local/bin:/usr/local/share/dotnet:/usr/lib/cargo/bin:$HOME/.cargo/bin:$PATH"
typeset -U path PATH

# kitty, alacritty use CPU instead of GPU
# export LIBGL_ALWAYS_SOFTWARE=1

export KEYTIMEOUT=2
export PASSWORD_STORE_CHARACTER_SET='[:alnum:]!&%^@{}[]()'
export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_TYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export CGO_ENABLED=0
export EDITOR=vim
export VIRTUAL_ENV_DISABLE_PROMPT=1
export XCURSOR_SIZE=60
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES
export MANPAGER='nvim +Man!'
export MANWIDTH=999

if [[ $OSTYPE == "linux-gnu"* ]]; then
  export DISPLAY=:0.0
fi

if [[ $OSTYPE == "darwin"* ]]; then
  defaults write -g KeyRepeat -int 1
  defaults write -g InitialKeyRepeat -int 20
  # defaults delete -g KeyRepeat
  # defaults delete -g InitialKeyRepeat
fi

fw () {
  if [[ $OSTYPE == "darwin"* ]]; then
      /usr/libexec/ApplicationFirewall/socketfilterfw --getglobalstate
  fi
}

############## Shell options ##############
setopt MENU_COMPLETE
unsetopt LIST_AMBIGUOUS

setopt AUTO_PUSHD PUSHD_SILENT PUSHD_TO_HOME
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_MINUS

# glob expansion and sorting
setopt extended_glob
setopt glob_dots
setopt numeric_glob_sort

# setopt COMPLETE_IN_WORD
setopt AUTO_LIST
setopt COMBINING_CHARS
setopt NO_BEEP
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt HIST_EXPIRE_DUPS_FIRST
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt interactivecomments
setopt PROMPT_SP
setopt NO_HUP
setopt nonomatch
setopt notify
setopt numericglobsort
setopt promptsubst
setopt autopushd
setopt autocd

############## History configuration ##############
export HISTFILE=~/.zsh_history
export HISTSIZE=2000
export SAVEHIST=1999
# export HISTIGNORE='ls:ll:proxychains:pwd:sudo ssh*:echo'
HISTDUP=erase
PROMPT_EOL_MARK=""

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RESET='\033[0m'

############## Aliases ##############

alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g ......='../../../../..'
alias ll="ls -loah"
alias vil='vim -u ~/.vimrc_min'
alias vim='nvim -n'
alias vi='nvim -n'
alias vio=/usr/bin/vi
alias k='kubectl '
# alias vl='vim -c \"normal '0\" -c "bn" -c \"bd\"'
alias vl='nvim -c "normal '\''0" -c "bn" -c "bd"'
alias gd='git diff'
alias gs='git status --untracked-files=all'
alias tf='terraform'
alias ssh='TERM=xterm-256color ssh '
alias tree="tree -a -I '*.pyc|__pycache__|venv|.git'"
alias xargs='xargs '
alias ls='ls --color'
alias less='less -R'
alias pb="ansible-playbook "
alias god='go build -gcflags="all=-N -l"'

# Set the number of directories to remember
DIRSTACKSIZE=9

# Directory movement aliases
alias -- -='cd -'
alias 0='cd -0'
alias 1='cd -1'
alias 2='cd -2'
alias 3='cd -3'
alias 4='cd -4'
alias 5='cd -5'
alias 6='cd -6'
alias 7='cd -7'
alias 8='cd -8'
alias 9='cd -9'

# Save the directory stack on exit
chpwd () {
    print -l $PWD ${(u)dirstack} >~/.zdirs
}

# Load the directory stack at startup
if [[ -f ~/.zdirs ]]; then
    dirstack=( ${(f)"$(< ~/.zdirs)"} )
    [[ -d $dirstack[1] ]] && cd $dirstack[1] && cd $OLDPWD
fi

############## Functions ##############

function d () {
  if [[ -n $1 ]]; then
    dirs "$@"
  else
    dirs -v | head -n 10
  fi
}

echo_red () {
  echo -e "${RED}$@${RESET}"
}

echo_green () {
  echo -e "${GREEN}$@${RESET}"
}

# Suspend and foreground Neovim with ctrl+z
toggle () {
  fg %nvim
}

runner () {
  if ! command -v nodemon &>/dev/null; then
    npm install -g nodemon
  fi
  if [ $# -lt 2 ]; then
    echo_green Examples
    echo_green runner go run main.go
    echo_green runner python -m flask.run
    return
  fi
  nodemon --exec $@ --signal SIGTERM
}

fixgit () {
  git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
}

ta () {
    if ! command -v tmux &> /dev/null; then
        echo "Error: tmux is not installed."
        return 1
    fi

    local SESSION_NAME="${1:-main}"

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

mkrole () {
  local dir1="$@"
  mydir="roles/${dir1// /_}"
  if [ -d $mydir ]; then
    echo "role $mydir already exists :("
    return 1
  fi
  echo "creating ansible role -> $mydir"
  for d in defaults files handlers meta tasks templates tests vars
  do
    mkdir -p $mydir/$d
    echo "created $mydir/$d (dir)"
  done
  for f in defaults handlers tasks meta vars
  do
    if [ ! -f "$mydir/$f/main.yml" ]; then
      echo '---' >> $mydir/$f/main.yml
      echo "created $mydir/$f/main.yml (file)"
    fi
  done
  echo "done!"
}

take () {
  [ -z "$1" ] && echo "Please provide an argument"
  local dir="$@"
  mkdir -p "${dir// /-}"; cd "${dir// /-}"
}

mktag () {
  [ -z "$1" ] && echo "Please provide an argument"
  git tag -a $1 -m "$@"; git push origin $1
}

rmtag () {
  [ -z "$1" ] && echo "Please provide an argument"
  git tag -d $1;git push --delete origin $1
}

_cdr () {
  mydir="$(git rev-parse --show-toplevel 2>/dev/null)"
  cd ${mydir:-.}
}
alias cdr=_cdr

ginit () {
  [ -f ./config ] && git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*" && echo_green "fixed bare repo..." && return
  git init "$@"
  [ ! -f .gitignore ] && cp ~/.dotfiles/git/.gitignore .gitignore || echo_green 'skipping .gitignore'
}

gitlog () {
  git log --oneline --graph --decorate --simplify-by-decoration --color --oneline --date=local --pretty=format:'%C(auto) %h %d %C(reset)%s (%C(cyan)%ad %ae%C(reset))' $@
}

jira () {
    my_dir=$PWD
    cdr
    git add .
    jira=$(git branch --show-current | grep -Eio "ntwk\-\d{1,20}")
    f=$(git status --porcelain | cut -c4- | head -n 4)
    more_changes=$(git status --porcelain | sed -n 5p)
    [ -n "$more_changes" ] && f="$f ..."
    if test -z "$1"; then
      git commit "-m $jira updates to -> ${f//$'\n'/ }"
    else
      comment="$@"
      git commit '-m' "$jira $comment -> ${f//$'\n'/ }"
    fi
    cd $my_dir
}

va () {
  if [[ -d $(git rev-parse --show-toplevel 2>/dev/null)/venv ]]; then
    source $(git rev-parse --show-toplevel)/venv/bin/activate
  else
    source $HOME/.virtualenvs/prod3/bin/activate
  fi
  echo $(which python3)
}

vd () {
  deactivate 2>/dev/null
  source $HOME/.virtualenvs/prod3/bin/activate
  echo $(which python3)
}

dev_env () {
  python3 -m venv ~/.virtualenvs/prod3
  source ~/.virtualenvs/bin/active
  pip install -U pip wheel
  pip install debugpy black mdformat pipdeptree rpdb ipython ipdb dns yamllint ansible ansible-lint
  pip install jq yp
}

vc () {
  deactivate 2>/dev/null
  my_dir=$PWD
  if [[ -d $(git rev-parse --show-toplevel 2>/dev/null) ]]; then
    cd $(git rev-parse --show-toplevel)
  fi
  venv_dir="${1:-venv}"
  python_version="${2:-python3}"
  $python_version --version
  $python_version -m venv $venv_dir && source $venv_dir/bin/activate && pip install pip wheel -U || exit 1
  pip install jq yq pyright black pipdeptree debugpy pytest yamllint pre-commit pynvim rpdb pdbpp ruff python-dotenv -U
  echo ""
  echo ""
  echo "*************** :) *******************"
  which python
  cd $my_dir
}

_d () {
  cdr
  cd "$(fd -td -HI --exclude '.git' --exclude '__pycache__' . | fzf)"
}

# see ~/.config/fd/ignore
vs () {
  vim "$(fd --type f -H --no-ignore-vcs | fzf --height 30% --reverse --border)" || return
}

fcd () {
    local dir
    dir=$(find ${1:-.} -path '*/\.*' -prune -o -type d -print 2> /dev/null | fzf +m) && cd "$dir"
}

gb () {
  git checkout $(git branch -a | fzf)
}

d () {
  if [[ -n $1 ]]; then
    dirs "$@"
  else
    dirs -v | head -n 10
  fi
}

############## Completion system ##############

if type brew &>/dev/null; then
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
fi

# Completion system
autoload -Uz compinit
if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

# Completion settings
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# shift+tab
bindkey '^[[Z' reverse-menu-complete

############## Key bindings ##############

bindkey -v
bindkey "^E" end-of-line
bindkey "^A" beginning-of-line
bindkey "^N" down-line-or-history
bindkey "^O" accept-line-and-down-history
bindkey "^P" up-line-or-history
bindkey ' ' magic-space
bindkey "^R" fzf-history-widget
bindkey "^T" fzf-file-widget
zle -N toggle
bindkey '^Z' toggle
zle -N _d
bindkey -s '^G' _d^M

# copy to clipboard
bindkey -M vicmd 'y' vi-yank-pbcopy
function vi-yank-pbcopy {
    zle vi-yank
    echo "$CUTBUFFER" | pbcopy
}
zle -N vi-yank-pbcopy

# ci" in vi-mode
autoload -U select-quoted
zle -N select-quoted
for m in visual viopp; do
  for c in {a,i}{\',\",\`}; do
    bindkey -M $m $c select-quoted
  done
done

# ci{, ci(, di{ etc.. in vi-mode
autoload -U select-bracketed
zle -N select-bracketed
for m in visual viopp; do
  for c in {a,i}${(s..)^:-'()[]{}<>bB'}; do
    bindkey -M $m $c select-bracketed
  done
done

############## FZF configuration ##############

# export FZF_DEFAULT_OPTS='
# --height 40% --no-preview
# --color=bg+:#0a1623,bg:#0a1623,spinner:#f5e0dc,hl:#f38ba8
# --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc
# --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8'

export FZF_DEFAULT_OPTS='--height 40% --no-preview'

if command -v fd &>/dev/null; then
  # TODO: revisit this and use ~/.config/fd/ignore
  export FD_CMD='fd -I --type f --exclude ".git" --exclude "__pycache__" --exclude ".collections" --follow --hidden'
  export FZF_DEFAULT_COMMAND="$FD_CMD"
  export FZF_ALT_C_COMMAND="$FD_CMD"
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
fi

export FZF_COMPLETION_TRIGGER="**"

############## Load configurations ##############

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -d ~/.zsh/zsh-autosuggestions ] && source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

############## NVM configuration ##############

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

############## Starship prompt ##############

eval "$(starship init zsh)"

############## Zoxide ##############

if command -v zoxide &>/dev/null; then
  eval "$(zoxide init zsh)"
else
  echo "zoxide not installed..."
fi

############## Load virtual environment if it exists ##############

[ -n $VIRTUAL_ENV ] && . ~/.virtualenvs/prod3/bin/activate

# [[ $? == 0 ]] && clear -x && fw && uptime && echo "\n\"Follow the white rabbit... 🐇\"\n"

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/jlima/.cache/lm-studio/bin"
