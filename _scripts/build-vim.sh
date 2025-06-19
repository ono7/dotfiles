#!/usr/bin/env bash
#  Author:  Jose Lima (jlima)
#  Date:    2024-09-20 20:51

deactivate

set -e # Exit immediately if a command exits with a non-zero status.

log() {
  printf '\n[%s] - %s\n\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$*"
}

cleanup() {
  log "Cleaning up..."
  rm -rf ~/vim
}

trap cleanup EXIT

ARCH=$(uname -m)
if [[ "$ARCH" == "arm64" ]]; then
  # Apple Silicon optimizations (M1/M2/M3/M4)
  export CFLAGS="-O3 -march=native -mtune=native -flto"
  export CXXFLAGS="-O3 -march=native -mtune=native -flto"
  export LDFLAGS="-flto"
	log "Building for Apple Silicon ($ARCH) with CPU optimizations"
elif [[ "$ARCH" == "x86_64" ]]; then
  # x86_64 optimizations
  export CFLAGS="-O3 -march=native -mtune=native -flto -msse4.2 -mavx2"
  export CXXFLAGS="-O3 -march=native -mtune=native -flto -msse4.2 -mavx2"
  export LDFLAGS="-flto"
	log "Building for Linux (x86_64) with CPU optimizations"
fi

rm -rf "$HOME/.local/vim"
rm -rf "$HOME/vim"
rm -rf "$HOME/.vim/pack"

git clone https://github.com/vim/vim.git ~/vim
cd ~/vim

# Check if the system is macOS
if [[ "$OSTYPE" == "darwin"* ]]; then
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
    --with-compiledby="ono7" \
    --prefix="$HOME/.local/vim"
  BUILDFOR="MacOS"
else
  sudo apt update
  sudo apt install -y build-essential git make autoconf automake cmake pkg-config libncurses5-dev libncursesw5-dev libncurses-dev gettext python3-dev libpython3-dev ruby-dev liblua5.4-dev libperl-dev tcl-dev
  ./configure \
    --with-features=huge \
    --enable-multibyte \
    --enable-python3interp=yes \
    --with-python3-config-dir="$(python3-config --configdir)" \
    --enable-perlinterp=yes \
    --enable-rubyinterp=yes \
    --enable-cscope \
    --enable-terminal \
    --with-compiledby="ono7" \
    --prefix="$HOME/.local/vim" \
    --enable-gui=no \
    --enable-fail-if-missing
  BUILDFOR="Linux"
fi

make -j"$(nproc)"

if ! make install; then
  log "Error while installing vim"
  exit 1
fi

log "Installing fugitive"
mkdir -p ~/.vim/pack/plugins/start

git clone https://github.com/tpope/vim-fugitive.git ~/.vim/pack/plugins/start/vim-fugitive

echo ""
echo "Built for ${BUILDFOR} ${ARCH}"
echo "With compiler CFLAGS: ${CFLAGS}"
echo ""
exit 0
