#!/usr/bin/env bash

log() {
    printf '\n%s - %s\n\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$*"
}

log "attempting to boostrap neovim"

. ~/.bashrc

nvim
