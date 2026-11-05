#!/usr/bin/env bash
set -euo pipefail

# NOTE(jlima): Non-root GNU grep build compiled with Apple clang into user prefix ~/.local
WORK_DIR="$(mktemp -d -t user_grep_XXXXXX)"
PREFIX="${HOME}/.local"
BINDIR="${PREFIX}/bin"
MANDIR="${PREFIX}/share/man/man1"
VERSION="3.11"
URL="https://ftp.gnu.org/gnu/grep/grep-${VERSION}.tar.xz"
CPUS="$(sysctl -n hw.ncpu 2>/dev/null || echo 4)"

trap 'rm -rf "${WORK_DIR}"' EXIT

mkdir -p "${BINDIR}" "${MANDIR}"

echo "==> Fetching GNU grep ${VERSION}..."
curl -fsSL "${URL}" | tar -xJ -C "${WORK_DIR}"

cd "${WORK_DIR}/grep-${VERSION}"

echo "==> Configuring build..."
# NOTE(jlima): Disable NLS to avoid libintl/gettext linkage; PCRE falls back to standard POSIX regex if missing
./configure \
  --prefix="${PREFIX}" \
  --disable-nls

echo "==> Compiling..."
make -j"${CPUS}"

echo "==> Installing to ${PREFIX}..."
make install

# NOTE(jlima): Create 'ggrep' symlink to maintain compatibility with scripts expecting GNU prefix on macOS
ln -sf "${BINDIR}/grep" "${BINDIR}/ggrep"

echo "==> grep installed successfully:"
"${BINDIR}/grep" --version | head -n 1
