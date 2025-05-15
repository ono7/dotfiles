#!/bin/bash

log() {
  printf '\n%s - %s\n\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$*"
}

log "$0"

if [ "$(uname)" != 'Linux' ]; then
  log 'I only run on Linux..'
  exit 1
fi

cd ~/
rm -rf ~/nvim
rm -rf ~/nvim-linux64
rm -f ~/local/bin/nvim
rm -f ~/local/bin/shortpath
rm -rf ~/nvim-linux64.*
log "downloading neovim"
# curl -sL -O https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.tar.gz
curl -sL -O https://github.com/neovim/neovim-releases/releases/download/v0.11.1/nvim-linux-x86_64.tar.gz
[[ ! -f nvim-linux-x86_64.tar.gz ]] && log "failed to download neovim"
tar xzf nvim-linux-x86_64.tar.gz
mv nvim-linux-x86_64 nvim
rm nvim-linux.*
mkdir -p "$HOME/local/bin"
ln -sf ~/nvim/bin/nvim ~/local/bin/nvim

log "neovim for linux installed"
