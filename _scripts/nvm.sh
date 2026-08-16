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

# Load nvm into current shell session
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

log "install node"
nvm install node
nvm use --delete-prefix node

npm set strict-ssl false

# Remove any old conflicting npm prefix from ~/.npmrc if present
if [ -f "$HOME/.npmrc" ]; then
  npm config delete prefix || true
  npm config delete globalconfig || true
fi

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
