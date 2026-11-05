#!/usr/bin/env bash
set -euo pipefail

# NOTE(jlima): Non-root source build to user-space prefix
WORK_DIR="$(mktemp -d -t user_coreutils_XXXXXX)"
PREFIX="${HOME}/.local"
VERSION="9.5"
URL="https://ftp.gnu.org/gnu/coreutils/coreutils-${VERSION}.tar.xz"
CPUS="$(sysctl -n hw.ncpu 2>/dev/null || echo 4)"

trap 'rm -rf "${WORK_DIR}"' EXIT

echo "==> Fetching and building coreutils ${VERSION} into ${PREFIX}..."
curl -fsSL "${URL}" | tar -xJ -C "${WORK_DIR}"

cd "${WORK_DIR}/coreutils-${VERSION}"
./configure \
  --prefix="${PREFIX}" \
  --disable-nls \
  --without-gmp \
  --enable-install-program=hostname

make -j"${CPUS}"
make install

echo "==> coreutils binaries installed in ${PREFIX}/bin"
