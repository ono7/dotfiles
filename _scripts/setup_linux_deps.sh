#!/bin/bash

echo "$0"

if [ $(uname) != 'Linux' ]; then
  echo 'I only run on Linux..'
  exit 1
fi

echo "setting up locale"
sudo locale-gen "en_US.UTF-8"

echo 'setting up linux dependencies (apt/python)'

sudo apt update
sudo apt -y upgrade
sudo apt install -y build-essential libssl-dev curl tree zsh python3 silversearcher-ag \
  python3-pip python3-venv fd-find unzip wl-clipboard ripgrep stow make sqlite3 wget shfmt

echo 'done installing linux depenencies'

if command -v go &>/dev/null; then
  echo "installing goimports-reviser.."
  go install -v github.com/incu6us/goimports-reviser/v3@latest
  go install golang.org/x/tools/cmd/goimports@latest
fi

cd ~/
rm -rf ~/nvim
rm -rf ~/nvim-linux64
rm -f ~/local/bin/nvim
rm -f ~/local/bin/shortpath
rm -rf ~/nvim-linux64.*
wget https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.tar.gz
tar xzf nvim-linux64.tar.gz
mv nvim-linux64 nvim
rm nvim-linux64.*
ln -sf ~/nvim/bin/nvim ~/local/bin/nvim
echo "Neovim setup for linux complete"
