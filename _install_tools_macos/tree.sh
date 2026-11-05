#!/usr/bin/env bash
set -euo pipefail

# NOTE(jlima): Non-root tree build with direct binary installation to bypass flawed upstream Makefile
WORK_DIR="$(mktemp -d -t user_tree_XXXXXX)"
PREFIX="${HOME}/.local"
BINDIR="${PREFIX}/bin"
MANDIR="${PREFIX}/share/man/man1"
VERSION="2.2.1"
URL="https://gitlab.com/OldManProgrammer/unix-tree/-/archive/${VERSION}/unix-tree-${VERSION}.tar.gz"
CPUS="$(sysctl -n hw.ncpu 2>/dev/null || echo 4)"

trap 'rm -rf "${WORK_DIR}"' EXIT

mkdir -p "${BINDIR}" "${MANDIR}"

echo "==> Fetching and building tree ${VERSION}..."
curl -fsSL "${URL}" | tar -xz -C "${WORK_DIR}"

cd "${WORK_DIR}/unix-tree-${VERSION}"

# NOTE(jlima): Compile binary using clang with Darwin optimization flags
make -j"${CPUS}" \
  CC="clang" \
  CFLAGS="-O3 -Wall -fomit-frame-pointer" \
  LDFLAGS=""

# NOTE(jlima): Directly install binary and man page, eliminating Makefile /usr/local/bin fallback
install -m 0755 tree "${BINDIR}/tree"
install -m 0644 doc/tree.1 "${MANDIR}/tree.1"

echo "==> tree installed successfully: $(${BINDIR}/tree --version)"
