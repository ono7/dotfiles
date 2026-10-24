#!/usr/bin/env bash
#  Author:    Jose Lima (jlima)
#  Date:      2024-09-20 20:51
#  Updated for Arch Linux/Manjaro/Fedora/macOS support

set -euo pipefail

# NOTE(jlima): Ensure Homebrew runs fully non-interactive
export NONINTERACTIVE=1

log() {
  printf '\n[%s] - %s\n\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$*"
}

TAG="stable"
DESTDIR="neovim-${TAG}"
INITIAL_DIR=$(pwd)

cleanup() {
  log "Cleaning up..."
  cd "$INITIAL_DIR"
  rm -rf "${TAG}.tar.gz"
  rm -rf "${DESTDIR}"
}

trap cleanup EXIT ERR INT TERM

# Detect CPU core count dynamically across platforms
get_cpu_cores() {
  if command -v nproc >/dev/null 2>&1; then
    nproc
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    sysctl -n hw.ncpu
  else
    echo 2
  fi
}
CORES=$(get_cpu_cores)

# Detect architecture and set optimization flags
ARCH=$(uname -m)
if [[ "$ARCH" == "arm64" || "$ARCH" == "aarch64" ]]; then
  # NOTE(jlima): ARM64 / Apple Silicon optimizations
  export CFLAGS="-O3 -march=native -mtune=native -pipe"
  export CXXFLAGS="-O3 -march=native -mtune=native -pipe"
  export LDFLAGS="-Wl,-O1 -flto"
  log "Building for ARM64 (${ARCH}) with CPU optimizations"
elif [[ "$ARCH" == "x86_64" ]]; then
  # NOTE(jlima): x86_64 optimizations
  export CFLAGS="-O3 -march=native -mtune=native -pipe -msse4.2 -mavx2"
  export CXXFLAGS="-O3 -march=native -mtune=native -pipe -msse4.2 -mavx2"
  export LDFLAGS="-Wl,-O1,-s -flto"
  log "Building for Linux (x86_64) with CPU optimizations"
else
  # NOTE(jlima): Generic fallback for other architectures
  export CFLAGS="-O2 -pipe"
  export CXXFLAGS="-O2 -pipe"
  export LDFLAGS="-Wl,-O1"
  log "Building for generic architecture (${ARCH})"
fi

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
    brew update --quiet
    brew uninstall --ignore-dependencies neovim || true
    brew install ninja cmake gettext curl tree-sitter-cli node universal-ctags || true
  else
    log "Error: Homebrew is not installed. Please install Homebrew first."
    exit 1
  fi
# Check if the system is Arch Linux or Manjaro
elif [ -f /etc/arch-release ] || [ -f /etc/manjaro-release ] || command -v pacman >/dev/null 2>&1; then
  log "Arch Linux/Manjaro detected. Installing packages..."
  sudo pacman -Syu --noconfirm
  sudo pacman -R neovim --noconfirm || true
  sudo pacman -S --needed --noconfirm \
    base-devel cmake unzip ninja curl git tree-sitter-cli nodejs npm \
    libluv libutf8proc libuv libvterm luajit msgpack-c tree-sitter unibilium \
    tree-sitter-c tree-sitter-lua tree-sitter-markdown tree-sitter-query \
    tree-sitter-vim tree-sitter-vimdoc lua51-lpeg lua51-mpack
# Check if the system is RHEL or Fedora
elif [ -f /etc/redhat-release ] || [ -f /etc/fedora-release ]; then
  log "RHEL or Fedora detected. Installing packages..."
  sudo dnf -y install ninja-build cmake gcc gcc-c++ make unzip gettext curl glibc-gconv-extra tree-sitter-cli
# Check if the system is Debian-based (Ubuntu, Debian, etc.)
elif [ -f /etc/debian_version ]; then
  log "Debian-based system detected. Installing packages..."
  sudo apt-get update -y
  sudo apt-get install -y ninja-build gettext cmake unzip curl build-essential tree-sitter-cli ||
    sudo apt-get install -y ninja-build gettext cmake unzip curl build-essential nodejs npm
else
  log "Unsupported operating system. This script is intended for macOS, Arch Linux, Manjaro, RHEL, Fedora, Ubuntu, or Debian systems only."
  exit 1
fi

log "Building neovim with optimizations..."
make distclean

# Build dependencies first
mkdir -p .deps && cd .deps
cmake ../cmake.deps \
  -DCMAKE_C_FLAGS="$CFLAGS" \
  -DCMAKE_CXX_FLAGS="$CXXFLAGS" \
  -DCMAKE_EXE_LINKER_FLAGS="$LDFLAGS" \
  -DUSE_BUNDLED=ON \
  -DCMAKE_INTERPROCEDURAL_OPTIMIZATION=ON
make -j"$CORES"
cd ..

# Build Neovim
mkdir -p build && cd build
cmake .. \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX="$HOME/.local" \
  -DCMAKE_C_FLAGS="$CFLAGS" \
  -DCMAKE_CXX_FLAGS="$CXXFLAGS" \
  -DCMAKE_EXE_LINKER_FLAGS="$LDFLAGS" \
  -DENABLE_LTO=ON \
  -DCMAKE_INTERPROCEDURAL_OPTIMIZATION=ON

if ! make -j"$CORES"; then
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

export PATH="$HOME/.local/bin:$PATH"

log "Neovim installed successfully in $HOME/.local/bin/nvim"
log "Build complete"

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

log "attempting to bootstrap neovim plugins"
cleanup

nvim --headless "+lua vim.pack.update()" +qa
nvim --headless "+TSInstallMyParsers" +qa

echo ""
echo "Neovim built for platform ${ARCH}"
echo "With compiler CFLAGS: ${CFLAGS}"
echo ""


exit 0
