#!/bin/bash

echo "$0"

# install goimports used for code formatting/neovim
if command -v go &>/dev/null; then
  go install -v github.com/incu6us/goimports-reviser/v3@latest
  go install golang.org/x/tools/cmd/goimports@latest
  env CGO_ENABLED=0 go install -ldflags="-s -w" github.com/gokcehan/lf@latest
else
  echo "error: >>>>>>>>>>>>>>>>>>> go not installed <<<<<<<<<<<<<<<<<<<<"
fi
