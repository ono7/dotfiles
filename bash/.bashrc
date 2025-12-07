# added to support containers

stty -ixon 2>/dev/null

export GPG_TTY=$(tty)

export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_TYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export RIPGREP_CONFIG_PATH=$HOME/.ripgreprc

# swaybar/rofi
export XDG_DATA_DIRS="/usr/local/share:/usr/share"

# If not running interactively, don't do anything
case $- in
*i*) ;;
*) return ;;
esac

# set -o vi
bind -m vi-command ".":insert-last-argument
bind -m vi-insert "\C-l.":clear-screen
bind -m vi-insert "\C-a.":beginning-of-line
bind -m vi-insert "\C-e.":end-of-line
bind -m vi-insert "\C-w.":backward-kill-word
bind '"\C-f": forward-word'
bind '"\C-b": backward-word'
# Ctrl-Space sets mark
bind '"\C-@": set-mark'
# Ctrl-x jumps back (exchange point and mark)
bind '"\C-x": exchange-point-and-mark'

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

export HISTIGNORE="ls*:cat*:*AWS*:*SECRET*:*SSHPASS*"

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
  debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
xterm-color | *-256color) color_prompt=yes ;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
  if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # We have color support; assume it's compliant with Ecma-48
    # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
    # a case would tend to support setf rather than setaf.)
    color_prompt=yes
  else
    color_prompt=
  fi
fi

if [ "$color_prompt" = yes ]; then
  PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
  PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm* | rxvt*)
  PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
  ;;
*) ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias ls='ls --color=auto'
  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases

alias cds='cd $(fd -td | fzf)'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias clear="clear -x"
alias vl='nvim -c "normal '\''0" -c "bn" -c "bd"'
alias ts='date +%Y%m%d-%H%M%S'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

export TERM=xterm-256color
export CLICOLOR=1
export COLORTERM=truecolor

alias tree="tree -C -I '*.pyc|__pycache__|venv|.git'"
alias ll="ls -loah"

[[ -d ~/.tmp ]] || mkdir -p ~/.tmp

if [ -d "$HOME/local/bin" ]; then
  PATH="$PATH:$HOME/local/bin"
fi

if [ -d "$HOME/bin" ]; then
  PATH="$PATH:$HOME/bin"
fi

export PATH="/var/lib/snapd/snap/bin:$HOME/.fzf/bin:$HOME/.local/bin:$HOME/.deno/bin:$HOME/local/bin:/opt/homebrew/sbin:/usr/local/sbin:/snap/bin:/opt/homebrew/opt/grep/libexec/gnubin:/opt/homebrew/opt/gnu-sed/libexec/gnubin:$GOPATH/bin:$HOME/.rd/bin:$HOME/.luarocks/bin:/opt/homebrew/bin:$HOME/.npm-packages/bin:$HOME/local/node/bin:$HOME/local/yarn/bin:$HOME/bin:/usr/local/bin:/usr/local/share/dotnet:/usr/lib/cargo/bin:$HOME/.cargo/bin:$PATH"

if [[ -f ~/.virtualenvs/prod3/bin/activate && -z $VIRTUAL_ENV ]]; then
  source ~/.virtualenvs/prod3/bin/activate
fi

# Auto-detect and reactivate virtual environment in tmux
if [ -n "$TMUX" ] && [ -n "$VIRTUAL_ENV" ]; then
  if [ -f "$VIRTUAL_ENV/bin/activate" ]; then
    source "$VIRTUAL_ENV/bin/activate"
  fi
fi

if command -v nvim >/dev/null 2>&1; then
  export EDITOR=nvim
else
  export EDITOR=vim
fi

alias gd='git diff'
alias gs='git status'

# alias cdr='cd "$(git rev-parse --show-toplevel)"  &>/dev/null'
_cdr() {
  mydir="$(git rev-parse --show-toplevel 2>/dev/null)"
  cd ${mydir:-.}
}
alias cdr=_cdr

alias clear='clear -x'

vs() {
  nvim "$(fd --type f -H --no-ignore-vcs | fzf --height 30% --reverse --border)" || return
}

_d() {
  cdr
  cd "$(fd -td -HI --exclude '.git' --exclude '__pycache__' . | fzf)"
}

ginit() {
  # we are in a bare repo
  [ -f ./config ] && git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*" && echo_green "fixed bare repo..." && return
  # other wise lets do other things
  git init "$@"
  [ ! -f .gitignore ] && cp ~/.dotfiles/git/.gitignore .gitignore || echo_green 'skipping .gitignore'
}

gitl() {
  my_dir=$PWD
  cdr
  git add .
  if test -z "$1"; then
    git commit '-m updates'
  else
    git commit '-m' $1
  fi
  git push
  cd $my_dir
}

dotp() {
  my_dir=$PWD
  cd ~/.dotfiles
  git pull
  cd $my_dir
}

dotc() {
  my_dir=$PWD
  cd ~/.dotfiles
  git pull
  git add .
  git commit '-m' 'updates'
  git push
  cd $my_dir
}

vc() {
  deactivate 2>/dev/null
  my_dir=$PWD
  cdr
  venv_dir="${1:-venv}"
  python_version="${2:-python3}"
  $python_version --version
  $python_version -m venv $venv_dir && source $venv_dir/bin/activate && pip install pip wheel -U || return
  pip install jq yq pyright black pipdeptree debugpy pytest yamllint pynvim rpdb pdbpp ruff python-dotenv ansible ansible-lint -U
  echo ""
  echo ""
  echo ""
  echo "*************** :) *******************"
  which python
  cd $my_dir
}

vd() {
  deactivate 2>/dev/null
  source $HOME/.virtualenvs/prod3/bin/activate
}

ta() {
  if ! type tmux &>/dev/null; then
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

# activate virtual environment if there is one in this repo
va() {
  toplevel=$(git rev-parse --show-toplevel)
  [ -d "$toplevel/venv" ] && source "$toplevel/venv/bin/activate"

}

# deactivate virtual environment if there is one in this repo
vd() {
  deactivate 2>/dev/null
  source $HOME/.virtualenvs/prod3/bin/activate
}

if type zoxide &>/dev/null; then
  eval "$(zoxide init bash)"
else
  echo "zoxide not installed..."
fi

alias vim=nvim
alias vi=nvim
alias v=nvim
alias vil=vim

export FZF_DEFAULT_OPTS='--height 40% --no-preview'

if type fd &>/dev/null; then
  _fzf_compgen_path() {
    fd -I --hidden --follow --exclude ".git" . "$1"
  }

  # Use fd to generate the list for directory completion
  _fzf_compgen_dir() {
    fd -I --type d --hidden --follow --exclude ".git" . "$1"
  }
  export FZF_ALT_C_COMMAND='fd -I --type d --exclude .git --follow --hidden'
  export FZF_DEFAULT_COMMAND='fd -I --type f --exclude .git --follow --hidden'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
else
  echo 'download fd from: https://github.com/sharkdp/fd/releases'
fi

source ~/.zshenv

eval "$(fzf --bash)"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# fixes issue with poetry shell not activated propery.
# https://github.com/python-poetry/poetry/issues/571
## on .{bash,zsh,wtv}rc
poetry_shell() {
  deactivate 2>/dev/null
  . "$(dirname $(poetry run which python))/activate"
}

# unset display in wsl or vim will starup slow
[[ $(uname -a) == *"Microsoft"* ]] && unset DISPLAY

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

if command -v direnv &>/dev/null; then
  eval "$(direnv hook zsh)"
fi

clear && uptime

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/jlima/.cache/lm-studio/bin"
. "$HOME/.cargo/env"
