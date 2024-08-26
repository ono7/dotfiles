#!/usr/bin/env bash

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $*"
}

log "attempting to bootstrap neovim"

. ~/.bashrc

nvim
