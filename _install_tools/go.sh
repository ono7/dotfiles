#!/usr/bin/env bash
set -euo pipefail

# NOTE(jlima): Normalize kernel name to Go OS naming conventions
OS="$(uname -s)"
case "${OS}" in
  Linux)  GOOS="linux" ;;
  Darwin) GOOS="darwin" ;;
  *)
    echo "Unsupported OS: ${OS}" >&2
    exit 1
    ;;
esac

# NOTE(jlima): Map POSIX uname machine strings to Go architecture identifiers
ARCH="$(uname -m)"
case "${ARCH}" in
  x86_64)          GOARCH="amd64" ;;
  arm64 | aarch64) GOARCH="arm64" ;;
  *)
    echo "Unsupported architecture: ${ARCH}" >&2
    exit 1
    ;;
esac

# NOTE(jlima): Fail closed if latest stable version string is empty or unresolvable
GO_VER="$(curl -sSf 'https://go.dev/VERSION?m=text' | head -n1)"
if [ -z "${GO_VER}" ]; then
  echo "Failed to retrieve Go version" >&2
  exit 1
fi

INSTALL_DIR="${HOME}/.local"
mkdir -p "${INSTALL_DIR}"

TMP_DIR="$(mktemp -d)"
# NOTE(jlima): Guarantee isolation and deterministic cleanup of downloaded assets
trap 'rm -rf "${TMP_DIR}"' EXIT

ARCHIVE_NAME="${GO_VER}.${GOOS}-${GOARCH}.tar.gz"
ARCHIVE_PATH="${TMP_DIR}/${ARCHIVE_NAME}"

curl -fSL "https://go.dev/dl/${ARCHIVE_NAME}" -o "${ARCHIVE_PATH}"

# NOTE(jlima): Purge existing root before extraction to prevent stale package collisions
rm -rf "${INSTALL_DIR}/go"
tar -C "${INSTALL_DIR}" -xzf "${ARCHIVE_PATH}"
