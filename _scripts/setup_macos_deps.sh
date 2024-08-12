#!/bin/bash

echo "$0"

if command -v brew &>/dev/null; then
  brew install ansifilter wget tree go neovim rar clang-format zoxide grep netcat stow
  brew install fd cmake ack rg coreutils ssh-copy-id jq p7zip curl tmux universal-ctags mtr lua ninja rust
  brew install bpytop pinentry-mac
  brew install golang delve sqlite shfmt sshs
  brew install --cask alacritty
else
  echo "Install homebrew first!"
  exit 1
fi
