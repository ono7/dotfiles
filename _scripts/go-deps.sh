#!/bin/bash

echo "$0"

# install goimports used for code formatting/neovim
if command -v go &>/dev/null; then
  go install -v github.com/incu6us/goimports-reviser/v3@latest
  go install golang.org/x/tools/cmd/goimports@latest
else
  echo ">>>>>>>>>>>>>>>>>>> go not installed <<<<<<<<<<<<<<<<<<<<"
fi
