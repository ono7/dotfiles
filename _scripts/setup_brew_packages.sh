#!/usr/bin/env bash

set -euo pipefail

# Define log function to prevent unbound variable / missing command errors
log() {
  printf '\n%s - %s\n\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$*"
}

# Ensure Homebrew runs non-interactively without auto-cleanup pauses or analytics prompts
export HOMEBREW_NO_ENV_HINTS=1
export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_NO_INSTALL_CLEANUP=1
export NONINTERACTIVE=1

if command -v brew &>/dev/null; then
  log "Installing Homebrew packages..."

  # Install core formula dependencies
  brew install --formula --quiet \
    ansifilter wget tree go clang-format zoxide grep netcat stow \
    fd cmake ack rg coreutils ssh-copy-id jq p7zip curl universal-ctags mtr lua ninja rust \
    npm tree-sitter-cli gnu-sed eza \
    bpytop llvm git-delta rename zk direnv gron \
    delve sqlite shfmt sshs act shellcheck rlwrap btop || true

  # Head-only and cask packages
  brew install --HEAD tmux || true

  # Fonts and macOS casks
  if [[ "$OSTYPE" == "darwin"* ]]; then
    # pinentry-mac and GUI casks
    brew install pinentry-mac || true
    brew install --cask --no-quarantine font-iosevka-term-nerd-font font-meslo-lg-nerd-font alacritty || true
  else
    brew install --cask font-iosevka-term-nerd-font font-meslo-lg-nerd-font || true
  fi

  # Symlink lldb-dap (formerly lldb-vscode) or lldb-vscode if present
  BREW_PREFIX="$(brew --prefix)"
  mkdir -p "${BREW_PREFIX}/bin"

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
