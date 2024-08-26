#!/bin/bash

log() {
    printf '\n\n%s - %s\n\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$*"
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
curl -sL -O https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.tar.gz
[[ ! -f nvim-linux64.tar.gz ]] && log "failed to download neovim" && return
tar xzf nvim-linux64.tar.gz
mv nvim-linux64 nvim
rm nvim-linux64.*
mkdir -p "$HOME/local/bin"
ln -sf ~/nvim/bin/nvim ~/local/bin/nvim

echo
log "----------[ neovim for linux setup complete ]-----------"
echo
