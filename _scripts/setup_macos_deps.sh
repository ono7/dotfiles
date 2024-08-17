#!/bin/bash

echo "$0"

if command -v brew &>/dev/null; then
  brew install ansifilter wget tree go neovim rar clang-format zoxide grep netcat stow
  brew install fd cmake ack rg coreutils ssh-copy-id jq p7zip curl tmux universal-ctags mtr lua ninja rust
  brew install bpytop pinentry-mac llvm
  brew install golang delve sqlite shfmt sshs act kitty
  brew install --cask alacritty
  ln -s "$(brew --prefix)"/opt/llvm/bin/lldb-vscode "$(brew --prefix)"/bin/
else
  echo "Install homebrew first!"
  exit 1
fi
