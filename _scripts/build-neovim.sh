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

rm -rf "$HOME"/.local/bin/nvim

if [[ $OSTYPE == "linux-gnu"* ]]; then
  log installing linux deps
  sudo apt-get install -y ninja-build gettext cmake unzip curl build-essential
fi

if [[ $OSTYPE == "darwin"* ]]; then
  log installing mac deps
  brew uninstall neovim
  brew install ninja cmake gettext curl
fi

if ! make CMAKE_BUILD_TYPE=Release CMAKE_INSTALL_PREFIX="$HOME"/.local; then
  cleanup
  log error while building neovim && exit 1
fi

if ! make install; then
  cleanup
  rm -rf ${DESTDIR}
  log error while installing neovim && exit 1
fi

cleanup
log neovim installed successfully in "$HOME"/.local/bin/nvim

log build complete
which nvim
