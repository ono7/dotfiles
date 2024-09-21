#!/usr/bin/env bash
#  Author:  Jose Lima (jlima)
#  Date:    2024-09-20 20:51

# build optimization...
export CFLAGS="-O3 -march=native -mtune=native"
export CXXFLAGS="-O3 -march=native -mtune=native"

set -e # Exit immediately if a command exits with a non-zero status.

log() {
  printf '\n\n[%s] - %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$*"
}

TAG="stable"
DESTDIR="neovim-stable"
INITIAL_DIR=$(pwd)

cleanup() {
  log "Cleaning up..."
  cd "$INITIAL_DIR"
  rm -rf "${TAG}.tar.gz"
  rm -rf "${DESTDIR}"
}

trap cleanup EXIT

log "Cleaning artifacts..."
log "Downloading neovim"
curl -LO "https://github.com/neovim/neovim/archive/refs/tags/${TAG}.tar.gz"
tar xzf "${TAG}.tar.gz"
log "Changing dirs"
cd "${DESTDIR}"
log "Cleaning build"
make distclean || true
make clean || true
rm -rf build

# Check if the system is macOS
if [[ "$OSTYPE" == "darwin"* ]]; then
  log "macOS detected. Installing packages..."
  if command -v brew >/dev/null 2>&1; then
    brew uninstall neovim || true
    brew install ninja cmake gettext curl || true
  else
    log "Error: Homebrew is not installed. Please install Homebrew first."
    exit 1
  fi
# Check if the system is RHEL or Fedora
elif [ -f /etc/redhat-release ] || [ -f /etc/fedora-release ]; then
  log "RHEL or Fedora detected. Installing packages..."
  sudo dnf -y install ninja-build cmake gcc make unzip gettext curl glibc-gconv-extra
# Check if the system is Debian-based (Ubuntu, Debian, etc.)
elif [ -f /etc/debian_version ]; then
  log "Debian-based system detected. Installing packages..."
  sudo apt-get update
  sudo apt-get install -y ninja-build gettext cmake unzip curl build-essential
else
  log "Unsupported operating system. This script is intended for macOS, RHEL, Fedora, Ubuntu, or Debian systems only."
  exit 1
fi

if ! make CMAKE_BUILD_TYPE=Release CMAKE_INSTALL_PREFIX="$HOME/.local"; then
  log "Error while building neovim"
  exit 1
fi

rm -rf ~/nvim
rm -rf "$HOME/.local/bin/nvim"

if ! make install; then
  log "Error while installing neovim"
  exit 1
fi

log "Neovim installed successfully in $HOME/.local/bin/nvim"
log "Build complete"
log "Make sure $HOME/.local/bin is in \$PATH"
which nvim || echo "nvim not found in PATH"

exit 0
