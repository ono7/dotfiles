#!/usr/bin/env bash
set -euo pipefail

# NOTE(jlima): Detect platform and fetch matching delta binary into ~/.local/bin
mkdir -p "$HOME/.local/bin"

OS="$(uname -s)"
ARCH="$(uname -m)"

case "${OS}_${ARCH}" in
  Linux_x86_64)   TARGET="x86_64-unknown-linux-musl" ;;
  Linux_aarch64)  TARGET="aarch64-unknown-linux-musl" ;;
  Darwin_x86_64)  TARGET="x86_64-apple-darwin" ;;
  Darwin_arm64)   TARGET="aarch64-apple-darwin" ;;
  *) echo "Unsupported platform: ${OS}_${ARCH}" >&2; exit 1 ;;
esac

TAG=$(curl -s "https://api.github.com/repos/dandavison/delta/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
ARCHIVE_STEM="delta-${TAG}-${TARGET}"
URL="https://github.com/dandavison/delta/releases/download/${TAG}/${ARCHIVE_STEM}.tar.gz"

echo "Fetching delta ${TAG} for ${TARGET}..."

# NOTE(jlima): Use exact internal path to avoid BSD vs GNU tar wildcard discrepancies
curl -sL "${URL}" | tar -xz -C "$HOME/.local/bin" --strip-components=1 "${ARCHIVE_STEM}/delta"
chmod +x "$HOME/.local/bin/delta"

# Verification
"$HOME/.local/bin/delta" --version
