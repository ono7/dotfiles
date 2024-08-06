#!/bin/bash

set -e

cd ~/.dotfiles

echo "Running stow..."

export PATH="/opt/homebrew/sbin:/usr/local/sbin:$PATH"

if command -v stow &> /dev/null; then
  stow alacritty
  stow bash
  stow ctags
  stow gdb
  stow git
  stow nvim
  stow ssh
  stow sqlite
  stow dlv
  stow starship
  stow tmux
  stow zsh
else
    echo "stow is not installed, please install stow first..."
    exit 1
fi
echo "stow completed..."
