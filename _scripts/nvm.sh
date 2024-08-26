#!/usr/bin/env bash

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $*"
}

log "downloading nvm"

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

log "install node"

nvm install node

. ~/.bashrc

log "disable ssh verify - node"
npm set strict-ssl false

log "installing npm packages"
npm install -g lua-fmt prettier jsonlint typescript eslint jsonlint doctoc neovim

