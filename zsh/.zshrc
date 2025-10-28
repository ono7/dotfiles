# Uncomment next line to start profiling
# zmodload zsh/zprof

# Disable flow control (Ctrl+S/Ctrl+Q) which can cause apparent input delays
stty -ixon 2>/dev/null

# export GPG_TTY=$(tty)
export GPG_TTY="/dev/tty"

# swaybar/rofi
export XDG_DATA_DIRS="/usr/local/share:/usr/share"

############## Essential environment variables ##############

# export COLORTERM=truecolor
export GOPATH=$HOME/go
export RIPGREP_CONFIG_PATH=$HOME/.ripgreprc
export GOPRIVATE=github.com/ono7/utils,github.com/ono7/other

# export PATH="$HOME/.fzf/bin:$HOME/.local/bin:$HOME/.deno/bin:$HOME/local/bin:/opt/homebrew/sbin:/usr/local/sbin:/snap/bin:/opt/homebrew/opt/grep/libexec/gnubin:/opt/homebrew/opt/gnu-sed/libexec/gnubin:$GOPATH/bin:$HOME/.rd/bin:$HOME/.luarocks/bin:/opt/homebrew/bin:$HOME/.npm-packages/bin:$HOME/local/node/bin:$HOME/local/yarn/bin:$HOME/bin:/usr/local/bin:/usr/local/share/dotnet:/usr/lib/cargo/bin:$HOME/.cargo/bin:$PATH"

# Clean PATH building - detect actual OS, not mixed environment
if grep -q Microsoft /proc/version 2>/dev/null; then
    # We're in WSL - use Linux-appropriate paths only
    # Let WSL handle Windows PATH appending automatically
    export PATH="$HOME/.fzf/bin:$HOME/.local/bin:$HOME/.deno/bin:$HOME/local/bin:$GOPATH/bin:$HOME/.rd/bin:$HOME/.luarocks/bin:$HOME/.npm-packages/bin:$HOME/local/node/bin:$HOME/local/yarn/bin:$HOME/bin:/usr/local/bin:/usr/local/share/dotnet:/usr/lib/cargo/bin:$HOME/.cargo/bin:$PATH"
elif [[ $OSTYPE == "darwin"* ]]; then
    # Real macOS
    export PATH="$HOME/.fzf/bin:$HOME/.local/bin:$HOME/.deno/bin:$HOME/local/bin:/opt/homebrew/sbin:/usr/local/sbin:/opt/homebrew/opt/grep/libexec/gnubin:/opt/homebrew/opt/gnu-sed/libexec/gnubin:$GOPATH/bin:$HOME/.rd/bin:$HOME/.luarocks/bin:/opt/homebrew/bin:$HOME/.npm-packages/bin:$HOME/local/node/bin:$HOME/local/yarn/bin:$HOME/bin:/usr/local/bin:/usr/lib/cargo/bin:$HOME/.cargo/bin:$PATH"
else
    # Regular Linux
    export PATH="$HOME/.fzf/bin:$HOME/.local/bin:$HOME/.deno/bin:$HOME/local/bin:$GOPATH/bin:$HOME/.rd/bin:$HOME/.luarocks/bin:$HOME/.npm-packages/bin:$HOME/local/node/bin:$HOME/local/yarn/bin:$HOME/bin:/usr/local/bin:/usr/local/share/dotnet:/usr/lib/cargo/bin:$HOME/.cargo/bin:$PATH"
fi

typeset -U path PATH

# kitty, alacritty use CPU instead of GPU
# export LIBGL_ALWAYS_SOFTWARE=1

# export KEYTIMEOUT=1
export KEYTIMEOUT=20
export PASSWORD_STORE_CHARACTER_SET='[:alnum:]!&%^@{}[]()'
export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_TYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export CGO_ENABLED=0
export EDITOR=vim
export VIRTUAL_ENV_DISABLE_PROMPT=1
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES
# export MANPAGER='nvim +Man!'
export MANWIDTH=999

# OS-specific settings (only run what's needed)
if [[ $OSTYPE == "linux-gnu"* ]]; then
   export TERSTRSTRSTST=0
elif [[ $OSTYPE == "darwin"* ]]; then
  # Only run these settings if they haven't been set before
  # Create a sentinel file and check for its existence
  if [[ ! -f "$HOME/.macos_defaults_set" ]]; then
    defaults write -g ApplePressAndHoldEnabled -bool false
    defaults delete -g ApplePressAndHoldEnabled
    defaults write -g InitialKeyRepeat -int 10
    defaults write -g KeyRepeat -int 1
    defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
    defaults write -g CGFontRenderingFontSmoothingDisabled -bool NO
    defaults -currentHost write -g AppleFontSmoothing -int 0
    touch "$HOME/.macos_defaults_set"
  fi
fi

fw () {
  if [[ $OSTYPE == "darwin"* ]]; then
      /usr/libexec/ApplicationFirewall/socketfilterfw --getglobalstate
  fi
}

############## Shell options ##############

# Essential shell options (performance related)
setopt NO_BEEP
setopt NO_HUP
setopt nonomatch
setopt notify
setopt interactivecomments

# Directory navigation options
setopt AUTO_PUSHD PUSHD_SILENT PUSHD_TO_HOME
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_MINUS
setopt autocd

# History options
# Disable immediate history sharing for better performance
# unsetopt SHARE_HISTORY
# unsetopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_REDUCE_BLANKS

# Set the number of directories to remember
DIRSTACKSIZE=9

# Completion options (load more efficiently)
setopt MENU_COMPLETE
unsetopt LIST_AMBIGUOUS
setopt AUTO_LIST
setopt COMBINING_CHARS
setopt PROMPT_SP

unset zle_bracketed_paste

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
alias clear="clear -x"
alias vil='vim -u ~/.vimrc_min'
alias vim='nvim -n'
alias vi='nvim -n'
if [ -f $HOME/.local/vim/bin/vim ]; then
  alias v='~/.local/vim/bin/vim -u ~/.vimrc'
else
  alias v='vim -u ~/.vimrc'
fi
alias vio=/usr/bin/vi
alias k='kubectl '
# alias vl='vim -c \"normal '0\" -c "bn" -c \"bd\"'
alias vl='nvim -c "normal '\''0" -c "bn" -c "bd"'
alias gd='git diff'
alias gs='git status --untracked-files=all --short'
alias tf='terraform'
alias ssh='TERM=xterm-256color ssh '
alias tree="tree -a -I '*.pyc|__pycache__|venv|.git'"
alias xargs='xargs '
alias ls='ls --color'
alias less='less -R'
alias pb="ansible-playbook "
alias god='go build -gcflags="all=-N -l"'

alias ts='date +%Y%m%d-%H%M%S'

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

vls () {
  local sessions_dir="$HOME/vim/sessions"
  local project_name=$(basename "$PWD")
  local session_file="$sessions_dir/${project_name}.vim"

  if [[ -f "$session_file" ]]; then
    echo "Loading session for $project_name..."
    nvim -S "$session_file"
  else
    # Fallback to your original behavior
    nvim -c "normal '0" -c "bn" -c "bd"
  fi
}

# Load the directory stack at startup
if [[ -f ~/.zdirs ]]; then
    dirstack=( ${(f)"$(< ~/.zdirs)"} )
    [[ -d $dirstack[1] ]] && cd $dirstack[1] && cd $OLDPWD
fi

############## Functions ##############

# fixes issue with poetry shell not activated propery.
# https://github.com/python-poetry/poetry/issues/571
## on .{bash,zsh,wtv}rc

poetry_shell () {
  deactivate 2>/dev/null
  . "$(dirname $(poetry run which python))/activate"
  which python
}

fpass() {
    local password edit=0 clipboard=0

    # Parse options
    while getopts "ec" opt; do
        case $opt in
            e) edit=1 ;;
            c) clipboard=1 ;;
            \?) echo "Usage: fpass [-e] [-c]" >&2; return 1 ;;
        esac
    done

    # Get password selection
    password=$(find ~/.password-store -name "*.gpg" | \
               sed -r 's,(.*)\.password-store/(.*)\.gpg,\2,' | \
               fzf +m)

    if [[ -n "$password" ]]; then
        if [[ $edit -eq 1 ]]; then
            # Edit mode
            pass edit "$password"
        elif [[ $clipboard -eq 1 ]]; then
            # Clipboard mode
            pass -c "$password"
        else
            # Default: export to SSHPASS
            SSHPASS=$(pass show "$password" | head -n1)
            # intentional space to ignore pattern
              export SSHPASS
        fi
    fi
}

export HISTORY_IGNORE="(ls|cat|AWS|SECRET|SSHPASS)"

# alias nvimdiff='vim -d'
vimgd() {
    if [[ "$#" == 2 ]]; then
        local ref=${1}
        local gitrelfp=${2}
        gitfullfp=$(git ls-files --full-name $gitrelfp)
        fname=$(basename ${gitrelfp})
        tmpfname=/tmp/$(sed "s/\//-/g" <<< $ref)-$fname
        git show $ref:$gitfullfp > $tmpfname
        vim -d $tmpfname $gitrelfp -c "setlocal nomodifiable"  # RO ref buffer
    else
        echo "usage: vimdg <ref|branch|commit> <relative-file-path>"
        echo "vimgd feat-branch file.yaml"
        echo "vimgd origin/master file.yaml"
        echo "vimgd 91a89847a9 file.yaml"
        echo "vimgd HEAD~3 file.yaml"
    fi
}

cdf() {
  local file
  file=$(fd --type f | fzf --preview 'head -100 {}') && cd "$(dirname "$file")"
}

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
    if [ -f $(git rev-parse --show-toplevel)/pyproject.toml ]; then
      poetry_shell
    else
      source $(git rev-parse --show-toplevel)/venv/bin/activate
    fi
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

ct () {
  wd=$PWD
  cdr
  ctags -R --exclude=@$HOME/.ctagsignore
  cd $wd
}

# shift+tab
function setup_keys() {
    bindkey -v
    bindkey "^E" end-of-line
    bindkey "^A" beginning-of-line
    bindkey "^N" down-line-or-history
    bindkey "^O" accept-line-and-down-history
    bindkey "^P" up-line-or-history
    bindkey ' ' magic-space
    bindkey "^R" fzf-history-widget
    bindkey "^F" fzf-file-widget
    zle -N toggle
    bindkey '^Z' toggle
    zle -N _d
    bindkey -s '^G' _d^M

    bindkey -M vicmd 'y' vi-yank-clipboard

    function vi-yank-clipboard {
        zle vi-yank
        if command -v pbcopy >/dev/null 2>&1; then
            echo "$CUTBUFFER" | pbcopy
        elif command -v wl-copy >/dev/null 2>&1; then
            echo "$CUTBUFFER" | wl-copy
        elif command -v xclip >/dev/null 2>&1; then
            echo "$CUTBUFFER" | xclip -selection clipboard
        fi
    }
    zle -N vi-yank-clipboard

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
    bindkey '^[[Z' reverse-menu-complete
    bindkey "^R" fzf-history-widget
}

bindkey "^R" fzf-history-widget

# install homebrew on linux and macos
# /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

if [ -f /home/linuxbrew/.linuxbrew/bin/brew ]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
fi

if type brew &>/dev/null; then
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
fi

# only run compinit once a day
autoload -Uz compinit
if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

# Comprehensive completion style configuration
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' verbose yes
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'
zstyle ':completion:*:messages' format '%F{purple}-- %d --%f'
zstyle ':completion:*:warnings' format '%F{red}-- No matches found --%f'
# zstyle ':completion:*:corrections' format '%F{green}-- %d (errors: %e) --%f'

# Load the menuselect keymap
zmodload zsh/complist

# set vi-style bindings for menu selection
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history

############## Key bindings ##############

############## FZF configuration ##############

# export FZF_DEFAULT_OPTS='--height 40% --no-preview'

# export FZF_DEFAULT_OPTS='
# --height 40%
# --layout=reverse
# --border=rounded
# --info=inline
# --color=bg+:#2D364A,bg:#171F2C,spinner:#9A82A0,hl:#8BC184
# --color=fg:#D6CFC7,header:#7E9F9D,info:#BFA46C,pointer:#C19999
# --color=marker:#8BC184,fg+:#B9C2E4,prompt:#B9C2E4,hl+:#8BC184
# --color=border:#6D778F,separator:#323C4D,scrollbar:#7591A8'

# export FZF_DEFAULT_OPTS='
# --height 40%
# --border=rounded
# --color=bg+:-1,bg:-1,spinner:#9A82A0,hl:#8BC184
# --color=fg:#D6CFC7,header:#7E9F9D,info:#BFA46C,pointer:#C19999
# --color=marker:#8BC184,fg+:#B9C2E4,prompt:#B9C2E4,hl+:#8BC184
# --color=border:#6D778F,separator:#323C4D,scrollbar:#7591A8'

export FZF_DEFAULT_OPTS='
--height 40%
--border=rounded
--color=bg+:#252a3e,bg:-1,spinner:#f5c2e7,hl:#a6e3a1
--color=fg:#D6CFC7,header:#94e2d5,info:#f9e2af,pointer:#f38ba8
--color=marker:#a6e3a1,fg+:-1,prompt:#cba6f7,hl+:#a6e3a1
--color=border:#6c7086,separator:#45475a,scrollbar:#585b70'

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

if [ ! -d ~/.zsh/zsh-autosuggestions ]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
  source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
else
  source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

############## NVM configuration ##############

export NVM_DIR="$HOME/.nvm"
[ -f "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -f "$NVM_DIR/zsh_completion" ] && \. "$NVM_DIR/zsh_completion"

############## Zoxide ##############

if command -v zoxide &>/dev/null; then
  eval "$(zoxide init zsh)"
else
  echo "zoxide not installed..."
fi

# Important completion options
setopt MENU_COMPLETE
unsetopt LIST_AMBIGUOUS
setopt AUTO_LIST
setopt COMBINING_CHARS

# glob expansion *test<tab>
setopt extended_glob
setopt glob_complete
setopt no_case_glob
setopt numeric_glob_sort

# Run the setup function
setup_keys

# Make sure these options are set
setopt COMPLETE_IN_WORD
setopt ALWAYS_TO_END

############## Load virtual environment if it exists ##############

if [[ -f ~/.virtualenvs/prod3/bin/activate && -z $VIRTUAL_ENV ]]; then
  source ~/.virtualenvs/prod3/bin/activate
fi

# Auto-detect and reactivate virtual environment in tmux
if [ -n "$TMUX" ] && [ -n "$VIRTUAL_ENV" ]; then
  if [ -f "$VIRTUAL_ENV/bin/activate" ]; then
    source "$VIRTUAL_ENV/bin/activate"
  fi
fi

# [[ $? == 0 ]] && clear -x && fw && uptime && echo "\n\"Follow the white rabbit... 🐇\"\n"

if command -v direnv &>/dev/null; then
  eval "$(direnv hook zsh)"
fi

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/jlima/.cache/lm-studio/bin"

# remove control+t (fzf)
bindkey -r '^T'

# if ! infocmp -l -x | grep Smulx &> /dev/null; then
#   echo "building .... ${TERM}"
#
#   infocmp > /tmp/${TERM}.ti
#   # Use sed to replace the smul capability with smul + Smulx
#   sed -i 's/smul=\\E\[4m,/smul=\\E\[4m, Smulx=\\E\[4:%p1%dm,/g' /tmp/${TERM}.ti
#   # Optionally compile the modified terminfo
#   tic -x /tmp/${TERM}.ti
#
#   if infocmp -l -x | grep Smulx &> /dev/null; then
#     echo "Undercurl support is now compiled and ready"
#   fi
# fi

# arch linux
if grep -qE "^ID=(arch|manjaro)" /etc/os-release 2>/dev/null || command -v pacman &>/dev/null; then
  alias p='sudo pacman -Sy'
  # this function is necessary for the foot terminal to be able to open new terminal to cwd
  autoload -U add-zsh-hook
  function osc7-pwd() {
    emulate -L zsh
    setopt extendedglob
    local LC_ALL=C
    printf '\e]7;file://%s%s\e\' $HOST ${PWD//(#m)([^@-Za-z&-;_~])/%${(l:2::0:)$(([##16]#MATCH))}}
  }
  function chpwd-osc7-pwd() {
    (( ZSH_SUBSHELL )) || osc7-pwd
  }
  add-zsh-hook -Uz chpwd chpwd-osc7-pwd
fi

############## Starship prompt ##############

if command -v starship &>/dev/null; then
  eval "$(starship init zsh)"
else
  echo "starship not installed"
fi
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
