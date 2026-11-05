#!/usr/bin/env bash

set -euox pipefail

log() {
  printf '\n%s - %s\n\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$*"
}

# NOTE(jlima): Export CI and Homebrew variables to bypass all interactive prompts and telemetry
export CI=1
export NONINTERACTIVE=1
export HOMEBREW_NO_ENV_HINTS=1
export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_NO_INSTALL_CLEANUP=1
export HOMEBREW_NO_INSTALL_UPGRADE=1

if command -v brew &>/dev/null; then
  log "Installing Homebrew packages..."

  # NOTE(jlima): Core formula dependencies installed non-interactively
  brew install --formula --quiet \
    ansifilter wget tree go clang-format zoxide grep netcat stow \
    fd cmake ack rg coreutils ssh-copy-id jq p7zip curl universal-ctags mtr lua ninja rust \
    npm tree-sitter-cli gnu-sed eza \
    bpytop llvm git-delta rename zk direnv gron \
    delve sqlite shfmt sshs act shellcheck rlwrap btop || true

  # NOTE(jlima): Explicit build from source without confirmation
  brew install --HEAD tmux || true

  # NOTE(jlima): Restrict Cask operations strictly to macOS targets
  if [[ "$OSTYPE" == "darwin"* ]]; then
    # brew install pinentry-mac || true
    brew install --cask --no-quarantine font-iosevka-term-nerd-font font-meslo-lg-nerd-font alacritty || true
  fi

  BREW_PREFIX="$(brew --prefix)"
  mkdir -p "${BREW_PREFIX}/bin"

  # NOTE(jlima): Resolve binary symlink idempotently
  if [[ -f "${BREW_PREFIX}/opt/llvm/bin/lldb-dap" ]]; then
    ln -fs "${BREW_PREFIX}/opt/llvm/bin/lldb-dap" "${BREW_PREFIX}/bin/"
  elif [[ -f "${BREW_PREFIX}/opt/llvm/bin/lldb-vscode" ]]; then
    ln -fs "${BREW_PREFIX}/opt/llvm/bin/lldb-vscode" "${BREW_PREFIX}/bin/"
  fi

  log "Homebrew installation completed."
else
  log "Install homebrew first!"
  exit 1
fi
