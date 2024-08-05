#/bin/bash

echo "$0"

if command -v brew &> /dev/null; then
  brew install ansifilter wget tree go neovim rar clang-format zoxide grep netcat
  brew install fd cmake ack rg coreutils ssh-copy-id jq p7zip curl tmux universal-ctags mtr lua ninja rust npm starship stow
  brew install bpytop pinentry-mac npm
  brew install golang delve
  brew install --cask alacritty
  npm install lua-fmt prettier jsonlint typescript eslint jsonlint doctoc -g
else
  echo "Install homebrew first!"
  exit 1
fi
