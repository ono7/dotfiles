#!/usr/bin/env bash
#  Author:  Jose Lima (jlima)
#  Date:    2024-09-20 20:51

set -e # Exit immediately if a command exits with a non-zero status.

log() {
  printf '\n[%s] - %s\n\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$*"
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

# Detect architecture and set optimization flags
ARCH=$(uname -m)
if [[ "$ARCH" == "arm64" ]]; then
  # Apple Silicon optimizations (M1/M2/M3/M4)
  export CFLAGS="-O3 -march=native -mtune=native -flto"
  export CXXFLAGS="-O3 -march=native -mtune=native -flto"
  export LDFLAGS="-flto"
  log "Building for Apple Silicon (${ARCH}) with CPU optimizations"
elif [[ "$ARCH" == "x86_64" ]]; then
  # x86_64 optimizations
  export CFLAGS="-O3 -march=native -mtune=native -flto -msse4.2 -mavx2"
  export CXXFLAGS="-O3 -march=native -mtune=native -flto -msse4.2 -mavx2"
  export LDFLAGS="-flto"
  log "Building for Linux (x86_64) with CPU optimizations"
fi

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
    brew uninstall --ignore-dependencies neovim || true
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

# if ! make CMAKE_BUILD_TYPE=Release CMAKE_INSTALL_PREFIX="$HOME/.local"; then
#   log "Error while building neovim"
#   exit 1
# fi

# Build with optimizations
if ! make CMAKE_BUILD_TYPE=Release \
  CMAKE_INSTALL_PREFIX="$HOME/.local" \
  CMAKE_C_FLAGS="$CFLAGS" \
  CMAKE_CXX_FLAGS="$CXXFLAGS" \
  ENABLE_LTO=ON \
  MIN_LOG_LEVEL=3 \
  ${JEMALLOC_FLAG:-} \
  CMAKE_EXE_LINKER_FLAGS="$LDFLAGS"; then
  log "Error while building neovim"
  exit 1
fi

rm -rf ~/nvim
rm -rf "$HOME/.local/bin/nvim"

if ! make install; then
  log "Error while installing neovim"
  exit 1
fi

log "remove matchparen.vim....."
# this is for performace when typing, disabled matchparen.nvim for best results and no latency when typing
find ~/.local/share/nvim -name 'matchparen.vim' -exec rm -f {} \;
if [ $? != 0 ]; then
  log "error finding matchparen.vim"
fi

log "Neovim installed successfully in $HOME/.local/bin/nvim"
log "Build complete"
log "Make sure $HOME/.local/bin is in \$PATH"
which nvim || echo "nvim not found in PATH"

echo ""
echo "Neovim built for platform ${ARCH}"
echo "With compiler CFLAGS: ${CFLAGS}"
echo ""
exit 0
