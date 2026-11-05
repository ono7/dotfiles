#!/usr/bin/env bash
set -euo pipefail

WORK_DIR="$(mktemp -d -t user_sed_XXXXXX)"
PREFIX="${HOME}/.local"
VERSION="4.9"
URL="https://ftp.gnu.org/gnu/sed/sed-${VERSION}.tar.xz"
CPUS="$(sysctl -n hw.ncpu 2>/dev/null || echo 4)"

trap 'rm -rf "${WORK_DIR}"' EXIT

echo "==> Fetching and building gnu-sed ${VERSION} into ${PREFIX}..."
curl -fsSL "${URL}" | tar -xJ -C "${WORK_DIR}"

cd "${WORK_DIR}/sed-${VERSION}"
./configure \
  --prefix="${PREFIX}" \
  --disable-nls \

make -j"${CPUS}"
make install

echo "==> sed installed in ${PREFIX}/bin"
