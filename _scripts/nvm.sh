#!/usr/bin/env bash
set -euo pipefail

log() {
  printf '\n%s - %s\n\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$*"
}

log "$0"

log "downloading nvm"
export NVM_DIR="$HOME/.nvm"
mkdir -p "$NVM_DIR"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash

# Load nvm
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Remove conflicting prefix/globalconfig entries directly from ~/.npmrc before installing Node
if [ -f "$HOME/.npmrc" ]; then
  sed -i '/prefix/d' "$HOME/.npmrc"
  sed -i '/globalconfig/d' "$HOME/.npmrc"
fi

log "install node"
nvm install --delete-prefix node
nvm use node

npm set strict-ssl false

log "installing npm packages"
npm install -g \
  lua-fmt \
  prettier \
  jsonlint \
  typescript \
  eslint \
  doctoc \
  neovim \
  lint-staged \
  lint-staged-shellcheck \
  eslint-formatter-compact
