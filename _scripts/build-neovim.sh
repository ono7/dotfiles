#!/usr/bin/env bash
#  Author:  Jose Lima (jlima)
#  Date:    2024-09-20 20:51

log() {
  printf '[%s] - %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$*"
}

WD=$PWD

TAG="stable"
DESTDIR="neovim-stable"

cleanup() {
  CD ${WD}
  rm -rf ${TAG}.tar.gz
  rm -rf ${DESTDIR}
}

trap cleanup EXIT

log cleaning artifacts..

log downloading neovim
curl -LO https://github.com/neovim/neovim/archive/refs/tags/${TAG}.tar.gz
tar xzf ${TAG}.tar.gz

log changing dirs

cd ${DESTDIR}

log cleaning build
make distclean
make clean
rm -rf build

# Check if the system is macOS
if [[ "$OSTYPE" == "darwin"* ]]; then
  log "macOS detected. Installing packages..."
  if command -v brew >/dev/null 2>&1; then
    brew uninstall neovim
    brew install ninja cmake gettext curl
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

if ! make CMAKE_BUILD_TYPE=Release CMAKE_INSTALL_PREFIX="$HOME"/.local; then
  log error while building neovim && exit 1
fi

rm -rf "$HOME"/.local/bin/nvim

if ! make install; then
  rm -rf ${DESTDIR}
  log error while installing neovim && exit 1
fi

log neovim installed successfully in "$HOME"/.local/bin/nvim

log build complete
log make sure "$HOME"/.local/bin is in $$PATH
which nvim
