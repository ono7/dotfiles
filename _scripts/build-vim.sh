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

ARCH=$(uname -m)

ARCH=$(uname -m)
if [[ "$ARCH" == "arm64" ]]; then
  # Apple Silicon optimizations (M1/M2/M3/M4)
  # export CFLAGS="-O3 -march=native -mtune=native -pipe -fPIC"
  # export CXXFLAGS="-O3 -march=native -mtune=native -pipe -fPIC"
  # export LDFLAGS="-Wl,-O1 -flto"

  export CFLAGS="-O3 -march=native -mtune=native -flto"
  export CXXFLAGS="-O3 -march=native -mtune=native -flto"
  export LDFLAGS="-flto"
  log "Building for Apple Silicon (${ARCH}) with CPU optimizations"
elif [[ "$ARCH" == "x86_64" ]]; then
  # x86_64 optimizations
  export CFLAGS="-O3 -march=native -mtune=native -pipe -fPIC -msse4.2 -mavx2"
  export CXXFLAGS="-O3 -march=native -mtune=native -pipe -fPIC -msse4.2 -mavx2"
  export LDFLAGS="-Wl,-O1 -flto"
  log "Building for Linux (x86_64) with CPU optimizations"
fi

rm -rf "$HOME/.local/vim"
rm -rf "$HOME/vim"
rm -rf "$HOME/.vim/pack"

git clone https://github.com/vim/vim.git ~/vim
cd ~/vim

# Check if the system is macOS
if [[ "$OSTYPE" == "darwin"* ]]; then
  log "Configuring for macOS"
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
    --prefix="$HOME/.local/vim"
else
  # Install dependencies for Linux systems
  install_dependencies

  log "Configuring for Linux"
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
    --prefix="$HOME/.local/vim" \
    --disable-netbeans \
    --disable-arabic \
    --disable-title \
    --disable-balloon-eval-term \
    --disable-rightleft \
    --enable-gui=no \
    --enable-fail-if-missing
fi

make -j"$(nproc)"

if ! make install; then
  log "Error while installing vim"
  exit 1
fi

log "Installing fugitive"
mkdir -p ~/.vim/pack/plugins/start
git clone https://github.com/tpope/vim-fugitive.git ~/.vim/pack/plugins/start/vim-fugitive

# log "remove matchparen.vim....."
# this is for performace when typing, disabled matchparen.nvim for best results and no latency when typing
# find ~/.local/vim -name 'matchparen.vim' -exec rm -f {} \;
# if [ $? != 0 ]; then
#   log "error finding matchparen.vim"
# fi

echo ""
echo "Vim built for platform ${ARCH}"
echo "With compiler CFLAGS: ${CFLAGS}"
echo ""
exit 0
