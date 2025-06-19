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

if grep -q "avx2" /proc/cpuinfo; then
  VECTOR_FLAGS="-msse4.2 -mavx2"
elif grep -q "sse4_2" /proc/cpuinfo; then
  VECTOR_FLAGS="-msse4.2"
else
  VECTOR_FLAGS=""
fi

export CFLAGS="-O3 -march=native -mtune=native -flto $VECTOR_FLAGS"
export CXXFLAGS="-O3 -march=native -mtune=native -flto $VECTOR_FLAGS"
export LDFLAGS="-flto"

rm -rf "$HOME/.local/vim"

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
  ./configure \
    --with-features=huge \
    --enable-multibyte \
    --enable-python3interp=yes \
    --with-python3-config-dir="$(python3-config --configdir)" \
    --enable-perlinterp=yes \
    --enable-luainterp=yes \
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

log "Built for $BUILDFOR with $CFLAGS"
exit 0
