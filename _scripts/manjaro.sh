#!/usr/bin/env bash
#  Jose Lima (jlima)
#  2025-08-05 00:26

set -Eeuo pipefail

cleanup() {
  echo "done!"
}

log() {
  printf '\n[%s] - %s\n\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$*"
}

trap cleanup EXIT

log upgrade and install deps

sudo pacman -Syu --noconfirm
sudo pacman -Sy stow --noconfirm

log removing unecessary packages

# this interferes with creating alphanumeric workspaces e.g. mod+w
sudo pacman -R sworkstyle --noconfirm

log installing sway for manjaro/arch

rm -rf ~/.config/sway
rm -rf ~/.config/foot

cd ~/.dotfiles

stow sway_manjaro
stow foot
stow starship
