#!/bin/sh
set -eu

# NOTE(jlima): enforce deterministic installation prefix conforming to ~/.local
PREFIX="${HOME}/.local"
BIN_DIR="${PREFIX}/bin"
mkdir -p "${BIN_DIR}" "${PREFIX}/lib" "${PREFIX}/include"

NCURSES_VER="6.4"
READLINE_VER="8.2"

CPUS="$(getconf _NPROCESSORS_ONLN 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || echo 2)"

BUILD_DIR="$(mktemp -d)"
trap 'rm -rf "${BUILD_DIR}"' EXIT INT TERM

# -----------------------------------------------------------------------------
# Step 1: Build static ncurses (skip if present)
# -----------------------------------------------------------------------------
if [ ! -f "${PREFIX}/lib/libncurses.a" ]; then
    echo "[*] Compiling static ncurses ${NCURSES_VER} to ${PREFIX}..."
    cd "${BUILD_DIR}"
    curl -fsSL "https://ftp.gnu.org/gnu/ncurses/ncurses-${NCURSES_VER}.tar.gz" | tar -xz
    cd "ncurses-${NCURSES_VER}"
    ./configure \
        --prefix="${PREFIX}" \
        --without-shared \
        --without-debug \
        --without-ada \
        --without-cxx \
        --enable-widec \
        --with-termlib
    make -j"${CPUS}"
    make install.libs
fi

# -----------------------------------------------------------------------------
# Step 2: Build static GNU readline (skip if present)
# -----------------------------------------------------------------------------
if [ ! -f "${PREFIX}/lib/libreadline.a" ]; then
    echo "[*] Compiling static readline ${READLINE_VER} to ${PREFIX}..."
    cd "${BUILD_DIR}"
    curl -fsSL "https://ftp.gnu.org/gnu/readline/readline-${READLINE_VER}.tar.gz" | tar -xz
    cd "readline-${READLINE_VER}"
    ./configure \
        --prefix="${PREFIX}" \
        --disable-shared \
        --enable-static \
        --with-curses="${PREFIX}" \
        CFLAGS="-I${PREFIX}/include -I${PREFIX}/include/ncursesw" \
        LDFLAGS="-L${PREFIX}/lib"
    make -j"${CPUS}"
    make install-static || true
fi

# -----------------------------------------------------------------------------
# Step 3: Fetch and build rlwrap with --without-libptytty
# -----------------------------------------------------------------------------
echo "[*] Resolving latest rlwrap release asset..."
ASSET_URL="$(curl -fsSL https://api.github.com/repos/hanslub42/rlwrap/releases/latest \
    | grep "browser_download_url.*rlwrap-.*\.tar\.gz" \
    | head -n 1 \
    | cut -d '"' -f 4)"

if [ -z "${ASSET_URL}" ]; then
    TAG="$(curl -fsSLI -o /dev/null -w "%{url_effective}" https://github.com/hanslub42/rlwrap/releases/latest | sed 's|.*/tag/v*||')"
    ASSET_URL="https://github.com/hanslub42/rlwrap/releases/download/v${TAG}/rlwrap-${TAG}.tar.gz"
fi

echo "[*] Compiling rlwrap to ${PREFIX}..."
cd "${BUILD_DIR}"
mkdir -p rlwrap-src
curl -fsSL "${ASSET_URL}" | tar -xz -C rlwrap-src --strip-components=1
cd rlwrap-src

if [ ! -f "./configure" ]; then
    if command -v autoreconf >/dev/null 2>&1; then
        autoreconf -vfi
    else
        echo "[-] ./configure missing and autoreconf not found on host" >&2
        exit 1
    fi
fi

# NOTE(jlima): bypass optional libptytty dependency and link against local static readline/ncurses
./configure \
    --prefix="${PREFIX}" \
    --without-libptytty \
    CPPFLAGS="-I${PREFIX}/include -I${PREFIX}/include/ncursesw" \
    CFLAGS="-I${PREFIX}/include -I${PREFIX}/include/ncursesw" \
    LDFLAGS="-L${PREFIX}/lib"

make -j"${CPUS}"
make install

echo "[+] Successfully installed rlwrap to ${BIN_DIR}/rlwrap"
