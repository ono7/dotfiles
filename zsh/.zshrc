# uncomment next line to start profiling
# zmodload zsh/zprof
# uset ttyctl -f to freeze terminal preventing any new changes to the tty
# ttyctl -u unfreezes the terminal

# WSL keyrate settings
# [HKEY_CURRENT_USER\Control Panel\Accessibility\Keyboard Response]
# "AutoRepeatDelay"="200"
# "AutoRepeatRate"="6"
# "DelayBeforeAcceptance"="0"
# "Flags"="59"
# "BounceTime"="0"

# -n = check if a variable is not empty
# -z = check if a variable is empty

# alacritty default rendering
# export LIBGL_ALWAYS_SOFTWARE=1

export COLORTERM=truecolor

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RESET='\033[0m'

echo_red() {
  echo -e "${RED}$@${RESET}"
}

echo_green() {
  echo -e "${GREEN}$@${RESET}"
}

toggle() {
  fg
}

zle -N toggle
bindkey '^Z' toggle

export GOPATH=$HOME/go
export GOPRIVATE=github.com/ono7/utils,github.com/ono7/other

# go build with no compiled optimizations for debugging
alias god='go build -gcflags="all=-N -l"'

export PATH="$HOME/.fzf/bin:$HOME/.local/bin:$HOME/.deno/bin:$HOME/local/bin:/opt/homebrew/sbin:/usr/local/sbin:/snap/bin:/opt/homebrew/opt/grep/libexec/gnubin:/opt/homebrew/opt/gnu-sed/libexec/gnubin:$GOPATH/bin:$HOME/.rd/bin:$HOME/.luarocks/bin:/opt/homebrew/bin:$HOME/.npm-packages/bin:$HOME/local/node/bin:$HOME/local/yarn/bin:$HOME/bin:/usr/local/bin:/usr/local/share/dotnet:/usr/lib/cargo/bin:$HOME/.cargo/bin:$PATH"

typeset -U path
typeset -U PATH
# 10ms for key sequences
export KEYTIMEOUT=2

export PASSWORD_STORE_CHARACTER_SET='[:alnum:]!&%^@{}[]()'

export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_TYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export CGO_ENABLED=0

# unset LSCOLOR

setopt MENU_COMPLETE
unsetopt LIST_AMBIGUOUS
setopt COMPLETE_IN_WORD
setopt AUTO_LIST

# autoload -Uz compinstall && compinstall

alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g ......='../../../../..'

runner () {
  if ! type nodemon &>/dev/null; then
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
  # github repos sometimes dont have remote setup correctly when cloned
  git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
}

ta() {
    if ! type tmux &> /dev/null; then
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

typeset -U path

# zsh completion
[ ! -d ~/.zsh/zsh-autosuggestions ] && git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions

if [ -d ~/.zsh/zsh-autosuggestions ]; then
  source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

autoload -Uz compinit && compinit

zstyle ':completion:*:default' list-colors ""
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion::complete:*' gain-privileges 1
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*'
zstyle ':completion:*' list-suffixes
zstyle ':completion:*' expand prefix suffix

# partial completion suggestions

ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_USE_ASYNC=true

# fix certain weird characters
setopt COMBINING_CHARS

# no beep, ever
setopt NO_BEEP

[[ -d ~/.tmp ]] || mkdir -p ~/.tmp

ZSH_DISABLE_COMPFIX="true"

export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES

# Uncomment the following line to disable auto-setting terminal title.
DISABLE_AUTO_TITLE="true"

# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

if [[ $OSTYPE == "linux-gnu"* ]]; then
  export DISPLAY=:0.0
fi

export EDITOR=vim

if [[ -f ~/nvim/bin/nvim ]]; then
  alias vim='~/nvim/bin/nvim'
  alias nvim='~/nvim/bin/nvim'
  # legacy vim
  alias vil=vim
  alias vimdiff='~/nvim/bin/nvim -d'
elif type nvim &>/dev/null; then
  alias vim="$(whence nvim)"
  alias nvim=vim
  alias vi=vim
  alias vil=vim
  alias vimdiff='nvim -d'
  export MANPAGER='nvim +Man!'
  export MANWIDTH=999
  export EDITOR=nvim
fi

alias ll="ls -loah"
alias vil='vim -u ~/.vimrc_min'
alias v=vim

# do not attempt to clear the terminal's scrollback buffer with E3 see: man clear
alias clear='clear -x '

alias k='kubectl '

alias vl="vim -c \"normal '0\" -c \"bn\" -c \"bd\""

# debug in headless mode, allows debugging session to start paused
# alias dlvh="dlv debug --headless --api-version=2 --listen=127.0.0.1:2345"

# functions

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
  git tag -a $1 -m "added tag $1"; git push origin $1
}

rmtag () {
  [ -z "$1" ] && echo "Please provide an argument"
  git tag -d $1;git push --delete origin $1
}

# lf file manager, drops you back off where you are when you exit lf
lfcd () {
    tmp="$(mktemp)"
    lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp"
        if [ -d "$dir" ]; then
            if [ "$dir" != "$(pwd)" ]; then
                cd "$dir"
            fi
        fi
    fi
}

vq () {
  # pass all args to rg via $@ .. allows to append rg flags, muhahah
  [ -z "$1" ] && echo "Please provide an argument"
  vim -q <(rg --vimgrep --pcre2 -i -S $@) +"copen 6"
}

timezsh() {
  shell=${1-$SHELL}
  for i in $(seq 1 10); do /usr/bin/time $shell -i -c exit; done
}

alias gd='git diff'
alias gs='git status --untracked-files=all'
# alias cdr='cd "$(git rev-parse --show-toplevel 2>/dev/null)"  &>/dev/null'

_cdr () {
  mydir="$(git rev-parse --show-toplevel 2>/dev/null)"
  cd ${mydir:-.}
}
alias cdr=_cdr

alias tf='terraform'
alias ssh='TERM=xterm-256color ssh '

# init new repo
ginit () {
  # we are in a bare repo
  [ -f ./config ] && git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*" && echo_green "fixed bare repo..." && return
  # other wise lets do other things
  git init "$@"
  [ ! -f .gitignore ] && cp ~/.dotfiles/git/.gitignore .gitignore || echo_green 'skipping .gitignore'
}

alias tree="tree -a -I '*.pyc|__pycache__|venv|.git'"

gitlog () {
  # graphical view of the commit logs, should be able to see
  # where a branch was cloned from
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
      # replace new line, using longest match //
      # $'\n' represents a newline character in bash. The $ sign here is telling the
      # shell to interpret the following characters ('\n') as a special escape
      # sequence, translating it into an actual newline character.
      #
      # So, in the expression ${f//$'\n'/ }, the first $ is used to get the value of
      # the f variable, and the second $ is used to specify a newline character that
      # you want to replace with a space within the value of f.
      git commit "-m $jira updates to -> ${f//$'\n'/ }"
    else
      comment="$@"
      git commit '-m' "$jira $comment -> ${f//$'\n'/ }"
    fi
    # commenting this out, start using squash or rebase in my workflow
    # if [ ! -z "$(git remote -v)" ]; then
    #   git push
    # fi
    cd $my_dir
}

# activate virtual environment if there is one in this repo
va () {
  if [[ -d $(git rev-parse --show-toplevel 2>/dev/null)/venv ]]; then
    source $(git rev-parse --show-toplevel)/venv/bin/activate
  else
    source $HOME/.virtualenvs/prod3/bin/activate
  fi
  echo $(which python3)
}

# deactivate virtual environment if there is one in this repo
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
  pip install jq yq pyright black pipdeptree debugpy pytest yamllint pre-commit pynvim rpdb pdbpp ruff python-dotenv ansible ansible-lint -U
  echo ""
  echo ""
  echo "*************** :) *******************"
  which python
  cd $my_dir
}

export VIRTUAL_ENV_DISABLE_PROMPT=1
export XCURSOR_SIZE=60

export FZF_DEFAULT_OPTS='
--height 40% --no-preview
--color=bg+:#0a1623,bg:#0a1623,spinner:#f5e0dc,hl:#f38ba8
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc
--color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8'

FD_CMD='fd -I --type f --exclude ".git" --exclude "__pycache__" --follow --hidden'
if type fd &>/dev/null; then
  _fzf_compgen_path() {
    fd -I --hidden --follow --exclude ".git" . "$1"
  }

  # Use fd to generate the list for directory completion
  _fzf_compgen_dir() {
    fd -I --type d --hidden --follow --exclude ".git" . "$1"
  }
  export FZF_ALT_C_COMMAND=$FD_CMD
  export FZF_DEFAULT_COMMAND=$FD_CMD
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
else
  echo 'download fd from: https://github.com/sharkdp/fd/releases'
  if [[ $OSTYPE == "darwin"* ]]; then
    brew install fd jq neovim alacritty llvm netcat && ln -s $(brew --prefix)/opt/llvm/bin/lldb-vscode $(brew --prefix)/bin/
  fi
fi

export FZF_COMPLETION_TRIGGER="**"

if type netcat &>/dev/null; then
  alias nc=netcat
fi

# pretty colors

export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=60'

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

zvm_after_init_commands+=('[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh')

eval "$(starship init zsh)"

# defaults to vi-mode, and let us toggle back and forth

bindkey -v

source <(fzf --zsh)

bindkey "^E" end-of-line
bindkey "^A" beginning-of-line
bindkey "^N" down-line-or-history
bindkey "^O" accept-line-and-down-history
bindkey "^P" up-line-or-history
bindkey "^R" fzf-history-widget
bindkey "^T" fzf-file-widget

# Adding a trailing space to the command being aliased causes other aliased commands to expand:
alias xargs='xargs '

starttunnel () {
  echo "starting ssh proxy"
  sudo ssh -N -f -D 127.0.0.1:6000 jlima@127.0.0.1 -p 2222 -o ServerAliveCountMax=3 -o ServerAliveInterval=3
}

proxyon () {
  if [ -n $1 ]; then
    networksetup -setsocksfirewallproxy Wi-Fi 127.0.0.1 6000
  else
    networksetup -setsocksfirewallproxy Wi-Fi 127.0.0.1 $1
  fi
  networksetup -setsocksfirewallproxystate Wi-Fi on
}

proxyoff () {
  networksetup -setsocksfirewallproxystate Wi-Fi off
}

_d () {
  cdr
  cd "$(fd -td -HI --exclude '.git' --exclude '__pycache__' . | fzf)"
}

# _d declare as widget for zsh
zle -N _d
bindkey -s '^G' _d^M

vs () {
  vim "$(fd --type f -HI --exclude "venv" --exclude ".git" --exclude "__pycache__" . | fzf --height 30% --reverse --border)" || return
}

fcd() {
    local dir
    dir=$(find ${1:-.} -path '*/\.*' -prune -o -type d -print 2> /dev/null | fzf +m) && cd "$dir"
}

gb() {
  git checkout $(git branch -a | fzf)
}

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

alias ls='ls --color'

# less support colors
alias less='less -R'

export HISTFILE=~/.zsh_history
# HISTSIZE should be > SAVEHIST or dups will show up
export HISTSIZE=3000   # the number of items for the internal history list
export SAVEHIST=2999   # maximum number of items for the history file
# export HISTTIMEFORMAT='[%F %T] '
export HISTIGNORE='ls:ll:proxychains:pwd:sudo ssh*:echo'
HISTDUP=erase

# The meaning of these options can be found in man page of `zshoptions`.
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt HIST_EXPIRE_DUPS_FIRST # remove dups first
setopt INC_APPEND_HISTORY # record command immediatly instead of waiting until exit
setopt SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS  # do not put duplicated command into history list
setopt HIST_SAVE_NO_DUPS  # do not save duplicated command
setopt HIST_REDUCE_BLANKS  # remove unnecessary blanks

setopt interactivecomments # allow comments in interactive mode

# add space to end of output if none was provided
setopt PROMPT_SP

# disable beep
setopt NO_BEEP

# do not send HUP when exiting, makes exiting faster
setopt NO_HUP
setopt nonomatch # hide error messages if there is no match for the pattern
setopt notify # repor the status of background tasks emmediately
setopt numericglobsort # sort filenames numerically
setopt promptsubst # enablne command substitution in prompt

# hide EOL sign ('%')
PROMPT_EOL_MARK=""

bindkey ' ' magic-space # do history expansion on space

# change directories
setopt autocd

export NVM_LAZY=1
# curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

if [[ $OSTYPE == "darwin"* ]];  then
  KRATE=2
  INITKRATE=10
  # show current settings:
  # defaults read NSGlobalDomain InitialKeyRepeat
  # normal is 2, lower is faster
  defaults write -g KeyRepeat -int $KRATE
  # normal minimum is 15 (225 ms) , higher is faster
  defaults write -g InitialKeyRepeat -int $INITKRATE

# allow holding key instead of mac default holding key to choose alternate key
  defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
fi

# unset display in wsl or vim will starup slow
[[ $(uname -a) == *"Microsoft"* ]] && unset DISPLAY

# freeze tty
ttyctl -f

# ttyctl -u to temporarely unlock the tty

# prevent terminal from getting garbled up
autoload -Uz add-zsh-hook

function reset_broken_terminal () {
	printf '%b' '\e[0m\e(B\e)0\017\e[?5l\e7\e[0;0r\e8'
}

add-zsh-hook -Uz precmd reset_broken_terminal

alias pb="ansible-playbook "

# remember directories
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

alias ls='ls --color'

# alias z=zoxide

function d () {
  if [[ -n $1 ]]; then
    dirs "$@"
  else
    dirs -v | head -n 10
  fi
}

# autoload -Uz add-zsh-hook

[ ! -d $HOME/.cache/zsh/ ] && mkdir -p $HOME/.cache/zsh/

DIRSTACKFILE="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/dirs"
if [[ -f "$DIRSTACKFILE" ]] && (( ${#dirstack} == 0 )); then
	dirstack=("${(@f)"$(< "$DIRSTACKFILE")"}")
	[[ -d "${dirstack[1]}" ]] && cd -- "${dirstack[1]}"
fi

chpwd_dirstack() {
	print -l -- "$PWD" "${(u)dirstack[@]}" > "$DIRSTACKFILE"
}
add-zsh-hook -Uz chpwd chpwd_dirstack

DIRSTACKSIZE='10'

setopt AUTO_PUSHD PUSHD_SILENT PUSHD_TO_HOME

## Remove duplicate entries
setopt PUSHD_IGNORE_DUPS

## This reverts the +/- operators.
setopt PUSHD_MINUS

[ ! -d ~/.tmux/plugins/tpm ] && git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
# load this last

[ -n $VIRTUAL_ENV ] && . ~/.virtualenvs/prod3/bin/activate

if type zoxide &>/dev/null; then
  eval "$(zoxide init zsh)"
else
  echo "zoxide not installed..."
fi

if ! type lf &>/dev/null; then
  echo lf not installed
  echo https://github.com/gokcehan/lf/releases
fi

# if the SSH_CONNECTION var is empty, startup tmux
# if [ -z $SSH_CONNECTION ]; then
#   type tmux &> /dev/null && ta || echo "tmux not found..."
# fi

clear && uptime
