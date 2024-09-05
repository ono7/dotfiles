#!/bin/bash

set -e

cd ~/.dotfiles

log() {
  printf '\n%s - %s\n\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$*"
}

log "$0"

log "Running stow..."

export PATH="/opt/homebrew/sbin:/usr/local/sbin:$PATH"

if type stow &>/dev/null; then
  stow bash
  stow ctags
  stow gdb
  stow git
  stow nvim
  # stow ssh
  stow sqlite
  stow dlv
  stow starship
  stow kitty
  stow tmux
  stow alacritty
  stow wezterm
  stow zsh
  stow jq
  stow lint-staged
  stow yamllint
else
  log "stow is not installed, please install stow first..."
  exit 1
fi
log "stow completed..."
