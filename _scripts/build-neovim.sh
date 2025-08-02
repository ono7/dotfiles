#!/usr/bin/env bash
#  Author:  Jose Lima (jlima)
#  Date:    2024-09-20 20:51
#  Updated for Arch Linux/Manjaro support
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
# Check if the system is Arch Linux or Manjaro
elif [ -f /etc/arch-release ] || [ -f /etc/manjaro-release ] || command -v pacman >/dev/null 2>&1; then
  log "Arch Linux/Manjaro detected. Installing packages..."
  # Remove existing neovim if installed via pacman
  sudo pacman -R neovim --noconfirm || true
  # Install build dependencies
  sudo pacman -S --needed --noconfirm base-devel cmake unzip ninja curl gettext
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
  log "Unsupported operating system. This script is intended for macOS, Arch Linux, Manjaro, RHEL, Fedora, Ubuntu, or Debian systems only."
  exit 1
fi

# Build with optimizations - using cmake directly for better control
log "Building neovim with optimizations..."
mkdir -p build
cd build

cmake .. \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX="$HOME/.local" \
  -DCMAKE_C_FLAGS="$CFLAGS" \
  -DCMAKE_CXX_FLAGS="$CXXFLAGS" \
  -DCMAKE_EXE_LINKER_FLAGS="$LDFLAGS" \
  -DENABLE_LTO=ON

if ! make -j$(nproc); then
  log "Error while building neovim"
  exit 1
fi

# Clean up old installation
rm -rf ~/nvim
rm -rf "$HOME/.local/bin/nvim"

if ! make install; then
  log "Error while installing neovim"
  exit 1
fi

log "Neovim installed successfully in $HOME/.local/bin/nvim"
log "Build complete"
log "Make sure $HOME/.local/bin is in \$PATH"

# Check if nvim is in PATH
if command -v nvim >/dev/null 2>&1; then
  log "✓ nvim found in PATH: $(which nvim)"
  log "✓ Version: $(nvim --version | head -1)"
else
  log "⚠ nvim not found in PATH. Add $HOME/.local/bin to your PATH:"
  log "  echo 'export PATH=\"\$HOME/.local/bin:\$PATH\"' >> ~/.bashrc"
  log "  # or for zsh:"
  log "  echo 'export PATH=\"\$HOME/.local/bin:\$PATH\"' >> ~/.zshrc"
fi

echo ""
echo "Neovim built for platform ${ARCH}"
echo "With compiler CFLAGS: ${CFLAGS}"
echo ""
exit 0
