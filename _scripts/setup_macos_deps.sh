#!/bin/bash

log() {
    printf '\n\n%s - %s\n\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$*"
}

log "$0"

if type brew &>/dev/null; then
  brew install ansifilter wget tree go neovim rar clang-format zoxide grep netcat stow
  brew install fd cmake ack rg coreutils ssh-copy-id jq p7zip curl tmux universal-ctags mtr lua ninja rust
  brew install bpytop pinentry-mac llvm git-delta
  brew install golang delve sqlite shfmt sshs act kitty
  brew install --cask alacritty
  ln -fs "$(brew --prefix)"/opt/llvm/bin/lldb-vscode "$(brew --prefix)"/bin/
else
  log "Install homebrew first!"
  exit 1
fi
