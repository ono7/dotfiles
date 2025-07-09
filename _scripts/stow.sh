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
  stow aerospace
  stow gdb
  stow git
  stow nvim
  # stow ssh
  stow sqlite
  stow rg
  stow fd
  stow starship
  stow kitty
  stow tmux
  stow alacritty
  stow ipython
  stow wezterm
  stow neovide
  stow zsh
  stow jq
  stow zk
  stow eslint
  stow lint-staged
  stow yamllint
  stow ghostty
  stow foot
else
  log "stow is not installed, please install stow first..."
  exit 1
fi
log "stow completed..."
