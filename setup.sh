#!/bin/bash

set -e

cd ~/.dotfiles

echo "Running stow..."

if command -v stow &> /dev/null; then
  stow -R alacritty
  stow -R bash
  stow -R ctags
  stow -R gdb
  stow -R git
  stow -R nvim
  stow -R ssh
  stow -R sqlite
  stow -R starship
  stow -R tmux
  stow -R zsh
else
    echo "stow is not installed, please install stow first..."
    exit 1
fi
echo "stow completed..."
