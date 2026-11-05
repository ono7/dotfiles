#!/usr/bin/env bash
set -euo pipefail

WORK_DIR="$(mktemp -d -t user_tree_XXXXXX)"
PREFIX="${HOME}/.local"
VERSION="2.1.1"
URL="https://oldmanprogrammer.net/code/tree/tree-${VERSION}.tgz"
CPUS="$(sysctl -n hw.ncpu 2>/dev/null || echo 4)"

trap 'rm -rf "${WORK_DIR}"' EXIT

echo "==> Fetching and building tree ${VERSION} into ${PREFIX}..."
curl -fsSL "${URL}" | tar -xz -C "${WORK_DIR}"

cd "${WORK_DIR}/tree-${VERSION}"
make -j"${CPUS}" \
  CC="clang" \
  CFLAGS="-O3 -Wall -fomit-frame-pointer" \
  LDFLAGS=""

make install \
  prefix="${PREFIX}" \
  MANDIR="${PREFIX}/share/man/man1"

echo "==> tree installed in ${PREFIX}/bin"
