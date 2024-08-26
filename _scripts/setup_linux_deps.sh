#!/bin/bash

echo "$0"

log() {
    printf '\n\n%s - %s\n\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$*"
}

if [ $(uname) != 'Linux' ]; then
  log 'I only run on Linux..'
  exit 1
fi

log "setting up locale"
sudo locale-gen "en_US.UTF-8"

log 'setting up linux dependencies (apt/python)'

sudo apt update
sudo apt -y upgrade
sudo apt remove -y nano
sudo apt install zoxide git-delta
sudo apt install -y build-essential libssl-dev curl tree zsh python3 python3.11 silversearcher-ag \
  python3.11-pip python3.11-venv fd-find unzip wl-clipboard ripgrep stow make sqlite3 wget shfmt zoxide

echo
log "------[ done: installing linux dependencies ]-------"
echo

if type snap &>/dev/null; then
  log "------[ snap: installing linux dependencies ]-------"
  sudo snap install go --classic
  sudo snap install --edge starship

fi

cd ~/
rm -rf ~/nvim
rm -rf ~/nvim-linux64
rm -f ~/local/bin/nvim
rm -f ~/local/bin/shortpath
rm -rf ~/nvim-linux64.*
curl -sL -O https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.tar.gz
[[ ! -f nvim-linux64.tar.gz ]] && log "failed to download neovim..." && return
tar xzf nvim-linux64.tar.gz
mv nvim-linux64 nvim
rm nvim-linux64.*
ln -sf ~/nvim/bin/nvim ~/local/bin/nvim

log "------[ Neovim setup for linux complete ]-------"


log "installing delta git pager"

ARCH=$(uname -m)
DELTA_VERSION="0.18.1"

mkdir -p ~/local/bin
rm -rf ~/local/bin/delta

rm -f delta-${DELTA_VERSION}-${ARCH}-unknown-linux-gnu.tar.gz
curl -sL -O https://github.com/dandavison/delta/releases/download/${DELTA_VERSION}/delta-${DELTA_VERSION}-${ARCH}-unknown-linux-gnu.tar.gz

tar xzvf delta-${DELTA_VERSION}-${ARCH}-unknown-linux-gnu.tar.gz
cp delta-${DELTA_VERSION}-${ARCH}-unknown-linux-gnu/delta ~/local/bin/delta
rm -rf delta-${DELTA_VERSION}-${ARCH}-unknown-linux-gnu*

if [[ -f ~/local/bin/delta ]]; then
  log "delta installed successfully"
else
  log "delta installation failed"
fi

