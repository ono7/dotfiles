#/bin/bash

echo "$0"

if command -v brew &>/dev/null; then
  brew install ansifilter wget tree go neovim rar clang-format zoxide grep netcat stow
  brew install fd cmake ack rg coreutils ssh-copy-id jq p7zip curl tmux universal-ctags mtr lua ninja rust npm starship
  brew install bpytop pinentry-mac npm
  brew install golang delve sqlite shfmt sshs
  brew install --cask alacritty
  npm install lua-fmt prettier jsonlint typescript eslint jsonlint doctoc -g
  # formatter used with conform.nvim
  go install -v github.com/incu6us/goimports-reviser/v3@latest
  go install golang.org/x/tools/cmd/goimports@latest
else
  echo "Install homebrew first!"
  exit 1
fi
