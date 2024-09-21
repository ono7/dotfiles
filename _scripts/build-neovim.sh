#!/usr/bin/env bash
#  Author:  Jose Lima (jlima)
#  Date:    2024-09-20 20:51

log() {
  printf '[%s] - %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$*"
}

TAG="stable"
DESTDIR="neovim-stable"

log cleaning artifacts..

rm -rf ${TAG}.tar.gz
rm -rf ${DESTDIR}

log downloading neovim
curl -LO https://github.com/neovim/neovim/archive/refs/tags/${TAG}.tar.gz
tar vxzf ${TAG}.tar.gz

log changing dirs

cd ${DESTDIR}

log cleaning build
make distclean
make clean
rm -rf build
rm -rf "$HOME"/.local/bin/nvim

if [[ $OSTYPE == "linux-gnu"* ]]; then
  log installing linux deps
  sudo apt-get install -y ninja-build gettext cmake unzip curl build-essential || echo "unable to install deps" && exit 1 || echo "unable to install deps" && exit 1
fi

if [[ $OSTYPE == "darwin"* ]]; then
  log installing mac deps
  brew install ninja cmake gettext curl
fi

log running make
if make CMAKE_BUILD_TYPE=Release CMAKE_INSTALL_PREFIX="$HOME"/.local; then
  if make install; then
    log neovim installed successfully in "$HOME"/.local/bin/nvim
  fi
fi

log build complete