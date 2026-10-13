#!/usr/bin/env bash
#  Author:    Jose Lima (jlima)
#  Date:      2024-09-20 20:51
#  Updated:   2026-10-12

set -euo pipefail

log() {
  printf '\n[%s] - %s\n\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$*"
}

cleanup() {
  log "Cleaning up..."
  rm -rf "$HOME/vim"
}

trap cleanup EXIT

install_dependencies() {
  if command -v dnf &>/dev/null; then
    log "Detected Fedora/RHEL - installing dependencies with dnf"
    sudo dnf install -y \
      gcc make git autoconf automake pkgconf \
      ncurses-devel gettext python3-devel
  elif command -v pacman &>/dev/null; then
    log "Detected Arch Linux - installing dependencies with pacman"
    sudo pacman -Syu --needed --noconfirm \
      base-devel git cmake pkgconf ncurses python gettext
  elif command -v apt &>/dev/null; then
    log "Detected Debian/Ubuntu - installing dependencies with apt"
    sudo apt update
    sudo apt install -y \
      build-essential git make autoconf automake cmake pkg-config \
      libncursesw5-dev libncurses-dev gettext \
      python3-dev libpython3-dev
  else
    log "Warning: Could not detect package manager. Assuming dependencies are installed."
  fi
}

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

case "$ARCH" in
arm64 | aarch64)
  export CFLAGS="-O3 -march=native -mtune=native -pipe"
  export CXXFLAGS="-O3 -march=native -mtune=native -pipe"
  export LDFLAGS="-Wl,-O1 -flto"
  log "Building for ARM64/aarch64 (${ARCH}) with CPU optimizations"
  ;;
x86_64)
  export CFLAGS="-O3 -march=native -mtune=native -pipe -msse4.2 -mavx2"
  export CXXFLAGS="-O3 -march=native -mtune=native -pipe -msse4.2 -mavx2"
  export LDFLAGS="-Wl,-O1,-s -flto"
  log "Building for Linux (x86_64) with CPU optimizations"
  ;;
*)
  export CFLAGS="-O2 -pipe"
  export CXXFLAGS="-O2 -pipe"
  export LDFLAGS=""
  log "Building for generic architecture (${ARCH})"
  ;;
esac

rm -rf "$HOME/.local/vim"
rm -rf "$HOME/.vim/pack"
rm -rf "$HOME/.viminfo"

if [[ $(id -u) -eq 0 ]]; then
  sudo rm -f /usr/bin/vim /usr/bin/vi /usr/bin/ex /usr/bin/view /usr/bin/rvim /usr/bin/vim*
fi

rm -rf "$HOME/vim"

# NOTE(jlima): Shallow clone reduces network/build latency.
git clone --depth=1 https://github.com/vim/vim.git "$HOME/vim"
cd "$HOME/vim"

if [[ "$OSTYPE" == "darwin"* ]]; then
  log "Configuring for macOS (${INSTALL_TYPE} installation)"
  ./configure \
    --with-features=huge \
    --enable-multibyte \
    --with-tlib=ncurses \
    --enable-python3interp=yes \
    --with-python3-command=/opt/homebrew/bin/python3 \
    --with-python3-config-dir="$(/opt/homebrew/bin/python3-config --configdir 2>/dev/null || true)" \
    --disable-perlinterp \
    --disable-rubyinterp \
    --disable-luainterp \
    --disable-tclinterp \
    --disable-cscope \
    --enable-terminal \
    --disable-netbeans \
    --disable-rightleft \
    --disable-balloon-eval-term \
    --disable-arabic \
    --disable-title \
    --disable-gui \
    --without-x \
    --with-compiledby="${USER}" \
    --prefix="${INSTALL_PREFIX}"
else
  install_dependencies

  log "Configuring for Linux (${INSTALL_TYPE} installation)"
  # NOTE(jlima): Link explicitly to ncursesw, drop X11 IPC latency and unused interpreters.
  ./configure \
    --with-features=huge \
    --enable-multibyte \
    --with-tlib=ncursesw \
    --enable-python3interp=yes \
    --with-python3-config-dir="$(python3-config --configdir 2>/dev/null || true)" \
    --disable-perlinterp \
    --disable-rubyinterp \
    --disable-luainterp \
    --disable-tclinterp \
    --disable-cscope \
    --enable-terminal \
    --disable-netbeans \
    --disable-arabic \
    --disable-rightleft \
    --disable-balloon-eval-term \
    --disable-title \
    --disable-gui \
    --without-x \
    --with-compiledby="${USER}" \
    --prefix="${INSTALL_PREFIX}" \
    --enable-fail-if-missing
fi

log "Building Vim with $(nproc) parallel jobs"
make -j"$(nproc)"

if ! make install; then
  log "Error while installing vim"
  exit 1
fi

if [[ $(id -u) -ne 0 ]]; then
  log "Installing vim-fugitive plugin"
  mkdir -p "$HOME/.vim/pack/plugins/start"
  [[ -d "$HOME/.vim/pack/plugins/start/vim-fugitive" ]] && rm -rf "$HOME/.vim/pack/plugins/start/vim-fugitive"
  git clone --depth=1 https://github.com/tpope/vim-fugitive.git "$HOME/.vim/pack/plugins/start/vim-fugitive"

  log "Installing vim-dispatch plugin"
  [[ -d "$HOME/.vim/pack/plugins/start/vim-dispatch" ]] && rm -rf "$HOME/.vim/pack/plugins/start/vim-dispatch"
  git clone --depth=1 https://github.com/tpope/vim-dispatch.git "$HOME/.vim/pack/plugins/start/vim-dispatch"
fi

echo ""
echo "=============================================="
echo "Vim successfully built and installed!"
echo "Installation type: ${INSTALL_TYPE}"
echo "Installation prefix: ${INSTALL_PREFIX}"
echo "Platform: ${ARCH}"
echo "Compiler flags: ${CFLAGS:-Not set}"
echo ""

if [[ $(id -u) -eq 0 ]]; then
  echo "Vim is now available system-wide at: ${INSTALL_PREFIX}/bin/vim"
else
  echo "Vim is available at: ${INSTALL_PREFIX}/bin/vim"
  echo "Make sure ${INSTALL_PREFIX}/bin is in your PATH"
fi

echo "=============================================="
exit 0
