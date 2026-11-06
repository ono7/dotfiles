#!/bin/bash

set -euo pipefail

log() {
  printf '\n%s - %s\n\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$*"
}

log "$0"

log "installing go for local user..."


export GOROOT="${HOME}/.local/go"
export GOPATH="${HOME}/go"
export PATH="${GOROOT}/bin:${GOPATH}/bin:${PATH}"

bash ~/.dotfiles/_install_tools/go.sh

# install goimports used for code formatting/neovim
if type go &>/dev/null; then
  go install -v github.com/incu6us/goimports-reviser/v3@latest
  go install golang.org/x/tools/cmd/goimports@latest
  go install github.com/go-delve/delve/cmd/dlv@latest
  go install github.com/shurcooL/markdownfmt@latest
  go install github.com/moorereason/mdfmt@latest
  go install github.com/fatih/gomodifytags@latest
  go install -v golang.org/x/tools/gopls@latest
  go install golang.org/x/tools/cmd/godoc@latest
  env CGO_ENABLED=0 go install -ldflags="-s -w" github.com/gokcehan/lf@latest
else
  log "error: >>>>>>>>>>>>>>>>>>> go not installed <<<<<<<<<<<<<<<<<<<<"
fi
