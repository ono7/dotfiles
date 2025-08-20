#!/usr/bin/env bash
#  Author:  Jose Lima (jlima)
#  Date:    2024-09-20 20:51
set -e # Exit immediately if a command exits with a non-zero status.

log() {
  printf '\n[%s] - %s\n\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$*"
}

cleanup() {
  log "Cleaning up..."
  rm -rf ~/vim
}

trap cleanup EXIT

# Function to detect package manager and install dependencies
install_dependencies() {
  if command -v pacman &>/dev/null; then
    log "Detected Arch Linux - installing dependencies with pacman"
    sudo pacman -Syu --needed --noconfirm \
      base-devel git cmake pkgconf ncurses python ruby lua perl tcl \
      libx11 libxtst libxt libxmu
  elif command -v apt &>/dev/null; then
    log "Detected Debian/Ubuntu - installing dependencies with apt"
    sudo apt update
    sudo apt install -y \
      build-essential git make autoconf automake cmake pkg-config \
      libncurses5-dev libncursesw5-dev libncurses-dev gettext \
      python3-dev libpython3-dev ruby-dev liblua5.4-dev libperl-dev tcl-dev \
      libx11-dev libxtst6 libxt-dev libxmu-dev
  else
    log "Warning: Could not detect package manager. Assuming dependencies are installed."
  fi
}

# Determine installation type based on user privileges
if [[ $(id -u) -eq 0 ]]; then
  INSTALL_PREFIX="/usr"
  INSTALL_TYPE="system-wide"
  log "Root user detected - performing system-wide installation (prefix: ${INSTALL_PREFIX})"
else
  INSTALL_PREFIX="$HOME/.local/vim"
  INSTALL_TYPE="user"
  log "Regular user detected - performing user installation (prefix: ${INSTALL_PREFIX})"
fi

ARCH=$(uname -m)

# Set compiler optimizations based on architecture
if [[ "$ARCH" == "arm64" ]]; then
  export CFLAGS="-O3 -march=native -mtune=native -pipe"
  export CXXFLAGS="-O3 -march=native -mtune=native -pipe"
  export LDFLAGS="-Wl,-O1 -flto"
  log "Building for Apple Silicon (${ARCH}) with CPU optimizations"
elif [[ "$ARCH" == "x86_64" ]]; then
  export CFLAGS="-O3 -march=native -mtune=native -pipe -msse4.2 -mavx2"
  export CXXFLAGS="-O3 -march=native -mtune=native -pipe -msse4.2 -mavx2"
  export LDFLAGS="-Wl,-O1,-s -flto"
  log "Building for Linux (x86_64) with CPU optimizations"
fi

# Clean up previous installations
rm -rf "$HOME/.local/vim"
rm -rf "$HOME/.vim/pack"

rm -rf "$HOME/vim"

# Clone and build Vim
git clone https://github.com/vim/vim.git ~/vim
cd ~/vim

# Configure based on OS and installation type
if [[ "$OSTYPE" == "darwin"* ]]; then
  log "Configuring for macOS (${INSTALL_TYPE} installation)"
  ./configure \
    --with-features=huge \
    --enable-multibyte \
    --enable-python3interp=yes \
    --with-python3-command=/opt/homebrew/bin/python3 \
    --with-python3-config-dir="$(/opt/homebrew/bin/python3-config --configdir)" \
    --enable-perlinterp=yes \
    --enable-luainterp=yes \
    --enable-rubyinterp=yes \
    --with-ruby-command="$(which ruby)" \
    --enable-cscope \
    --enable-terminal \
    --disable-netbeans \
    --disable-rightleft \
    --disable-balloon-eval-term \
    --disable-arabic \
    --disable-title \
    --with-compiledby="${USER}" \
    --prefix="${INSTALL_PREFIX}"
else
  # Always install dependencies for Linux
  install_dependencies

  log "Configuring for Linux (${INSTALL_TYPE} installation)"
  ./configure \
    --with-features=huge \
    --enable-multibyte \
    --enable-python3interp=yes \
    --with-python3-config-dir="$(python3-config --configdir)" \
    --enable-perlinterp=yes \
    --enable-rubyinterp=yes \
    --enable-cscope \
    --enable-terminal \
    --with-compiledby="${USER}" \
    --prefix="${INSTALL_PREFIX}" \
    --disable-netbeans \
    --disable-arabic \
    --disable-title \
    --disable-balloon-eval-term \
    --disable-rightleft \
    --enable-gui=no \
    --enable-fail-if-missing
fi

# Build
log "Building Vim with $(nproc) parallel jobs"
make -j"$(nproc)"

# Install
if ! make install; then
  log "Error while installing vim"
  exit 1
fi

# Post-installation setup (only for user installs)
if [[ $(id -u) -ne 0 ]]; then
  log "Installing vim-fugitive plugin"
  mkdir -p ~/.vim/pack/plugins/start
  [[ -d ~/.vim/pack/plugins/start/vim-fugitive ]] && rm -rf ~/.vim/pack/plugins/start/vim-fugitive
  git clone https://github.com/tpope/vim-fugitive.git ~/.vim/pack/plugins/start/vim-fugitive
fi

# Final status report
echo ""
echo "=============================================="
echo "Vim successfully built and installed!"
echo "Installation type: ${INSTALL_TYPE}"
echo "Installation prefix: ${INSTALL_PREFIX}"
echo "Platform: ${ARCH}"
echo "Compiler flags: ${CFLAGS}"
echo ""

if [[ $(id -u) -eq 0 ]]; then
  echo "Vim is now available system-wide at: ${INSTALL_PREFIX}/bin/vim"
else
  echo "Vim is available at: ${INSTALL_PREFIX}/bin/vim"
  echo "Make sure ${INSTALL_PREFIX}/bin is in your PATH"
fi

echo "=============================================="
exit 0
