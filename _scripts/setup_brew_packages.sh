#!/usr/bin/env bash
if type brew &>/dev/null; then
  brew install ansifilter wget tree go rar clang-format zoxide grep netcat stow
  brew install fd cmake ack rg coreutils ssh-copy-id jq p7zip curl universal-ctags mtr lua ninja rust
  brew install tmux --HEAD
  brew install bpytop pinentry-mac llvm git-delta rename zk direnv gron
  brew install golang delve sqlite shfmt sshs act shellcheck rlwrap btop
  brew install font-iosevka-term-nerd-font font-meslo-lg-nerd-font
  ln -fs "$(brew --prefix)"/opt/llvm/bin/lldb-vscode "$(brew --prefix)"/bin/
  # MacOS only
  if [[ $OSTYPE == "darwin"* ]]; then
    brew install --cask alacritty
  fi
else
  log "Install homebrew first!"
  exit 1
fi
