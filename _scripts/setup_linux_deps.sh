#!/bin/bash

log() {
  printf '\n%s - %s\n\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$*"
}

log "$0"

if [ "$(uname)" != 'Linux' ]; then
  log 'I only run on Linux..'
  exit 1
fi

log "setting up locale"
sudo locale-gen "en_US.UTF-8"

log 'setting up linux dependencies (apt/python)'

sudo apt-add-repository ppa:git-core/ppa -y
sudo apt update
sudo apt -y upgrade
sudo apt remove -y nano
# sudo apt install rename zoxide git-delta stow rlwrap -y
sudo apt install -y build-essential procps curl file git
sudo apt install -y libssl-dev tree zsh silversearcher-ag \
  fd-find unzip xclip ripgrep stow make sqlite3 wget shfmt shellcheck gron
# sudo apt install python3 python3.12 python3.12-pip python3.12-venv socat -y

# install python3.11
# sudo add-apt-repository ppa:deadsnakes/ppa
# sudo apt update
# sudo apt install python3.11 -y

# if type snap &>/dev/null; then
#   log "installing snap packages"
#   sudo snap install go --classic
#   sudo snap install universal-ctags btop
#   sudo snap install --edge starship
# fi

# log "installing delta git pager"

# ARCH=$(uname -m)
# DELTA_VERSION="0.18.1"
#
# mkdir -p ~/local/bin
# rm -rf ~/local/bin/delta
#
# rm -f delta-${DELTA_VERSION}-${ARCH}-unknown-linux-gnu.tar.gz
# curl -sL -O https://github.com/dandavison/delta/releases/download/${DELTA_VERSION}/delta-${DELTA_VERSION}-${ARCH}-unknown-linux-gnu.tar.gz
#
# tar xzvf delta-${DELTA_VERSION}-${ARCH}-unknown-linux-gnu.tar.gz
# cp delta-${DELTA_VERSION}-${ARCH}-unknown-linux-gnu/delta ~/local/bin/delta
# rm -rf delta-${DELTA_VERSION}-${ARCH}-unknown-linux-gnu*
#
# if [[ -f ~/local/bin/delta ]]; then
#   log "delta installed successfully"
# else
#   log "delta installation failed"
# fi

# log "installing direnv"
# curl -sfL https://direnv.net/install.sh | bash
