#!/bin/bash

echo "$0"

if [ $(uname) != 'Linux' ]; then
  echo 'I only run on Linux..'
  exit 1
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

echo
echo "----------[ neovim for linux setup complete ]-----------"
echo
