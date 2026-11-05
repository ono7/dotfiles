#!/usr/bin/env bash
set -euo pipefail

# NOTE(jlima): GNU Stow source build and local installation for macOS.
# Fetches latest release dynamically from GNU FTP; no Homebrew required.

PREFIX="${HOME}/.local"
SRC_URL="https://ftp.gnu.org/gnu/stow/stow-latest.tar.gz"
BUILD_DIR="$(mktemp -d -t stow-build.XXXXXX)"

cleanup() {
  rm -rf "${BUILD_DIR}"
}
trap cleanup EXIT

# NOTE(jlima): Check prerequisites (make/clang toolchain and perl).
if ! command -v make >/dev/null 2>&1; then
  echo "ERROR: 'make' not found. Run 'xcode-select --install' to install CLI developer tools." >&2
  exit 1
fi

if ! command -v perl >/dev/null 2>&1; then
  echo "ERROR: 'perl' runtime not detected on PATH." >&2
  exit 1
fi

echo "==> Fetching latest GNU Stow release from ${SRC_URL}..."
curl -fsSL "${SRC_URL}" -o "${BUILD_DIR}/stow-latest.tar.gz"

echo "==> Extracting archive..."
mkdir -p "${BUILD_DIR}/src"
# NOTE(jlima): Flatten source tree to handle dynamic version directory naming.
tar -xzf "${BUILD_DIR}/stow-latest.tar.gz" -C "${BUILD_DIR}/src" --strip-components=1

cd "${BUILD_DIR}/src"

echo "==> Configuring build targeting ${PREFIX}..."
./configure \
  --prefix="${PREFIX}" \
  PMDIR="${PREFIX}/share/perl5" \
  PERL="$(command -v perl)"

echo "==> Compiling..."
make -j"$(sysctl -n hw.ncpu 2>/dev/null || echo 2)"

echo "==> Running test suite..."
make check

echo "==> Installing to ${PREFIX}..."
make install

echo "==> Verification: $("${PREFIX}/bin/stow" --version | head -n 1)"

if [[ ":${PATH}:" != *":${PREFIX}/bin:"* ]]; then
  echo "WARNING: ${PREFIX}/bin is not in your PATH. Add it to ~/.zshrc:"
  echo "  export PATH=\"${PREFIX}/bin:\$PATH\""
fi
