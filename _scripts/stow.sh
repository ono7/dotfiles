#!/bin/bash

set -e

cd ~/.dotfiles

log() {
    printf '\n%s - %s\n\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$*"
}

log "Running stow..."

export PATH="/opt/homebrew/sbin:/usr/local/sbin:$PATH"

if type stow &> /dev/null; then
  stow alacritty
  stow kitty
  stow bash
  stow ctags
  stow gdb
  stow git
  stow nvim
  # stow ssh
  stow sqlite
  stow dlv
  stow starship
  stow tmux
  stow zsh
else
    log "stow is not installed, please install stow first..."
    exit 1
fi
log "stow completed..."
