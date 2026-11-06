#!/usr/bin/env bash
set -euo pipefail

# NOTE(jlima): Normalize macOS architecture mapping for GitHub release assets
ARCH="$(uname -m)"
case "${ARCH}" in
    x86_64)  ARCH_TAG="amd64" ;;
    arm64)   ARCH_TAG="arm64" ;;
    *)
        echo "ERROR: Unsupported architecture: ${ARCH}" >&2
        exit 1
        ;;
esac

TARGET_DIR="${HOME}/.local/bin"
mkdir -p "${TARGET_DIR}"

TMP_DIR="$(mktemp -d /tmp/podman-install.XXXXXX)"
# NOTE(jlima): Guarantee temporary file cleanup on exit
trap 'rm -rf "${TMP_DIR}"' EXIT

echo "Fetching latest Podman release version..."
# NOTE(jlima): Follow redirect to release tag URL to bypass GitHub API rate-limits and 301s
LATEST_URL="$(curl -fsSLI -o /dev/null -w "%{url_effective}" https://github.com/containers/podman/releases/latest)"
VERSION="${LATEST_URL##*/}"

if [[ -z "${VERSION}" || "${VERSION}" == "latest" ]]; then
    echo "ERROR: Failed to resolve latest Podman release tag" >&2
    exit 1
fi

echo "Resolved version: ${VERSION}"

# NOTE(jlima): Strip 'v' prefix if release asset filenames omit it (e.g. podman-remote-release-darwin_arm64.zip)
ASSET_URL="https://github.com/containers/podman/releases/download/${VERSION}/podman-remote-release-darwin_${ARCH_TAG}.zip"

echo "Downloading Podman ${VERSION} (${ARCH_TAG})..."
curl -LsSf "${ASSET_URL}" -o "${TMP_DIR}/podman.zip"

echo "Extracting release asset..."
unzip -q "${TMP_DIR}/podman.zip" -d "${TMP_DIR}/dist"

# NOTE(jlima): Locate binary dynamically to tolerate internal directory variations across releases
PODMAN_BIN="$(find "${TMP_DIR}/dist" -type f -name "podman" -perm +111 2>/dev/null || find "${TMP_DIR}/dist" -type f -name "podman" | head -n1)"

if [[ ! -f "${PODMAN_BIN}" ]]; then
    echo "ERROR: Extracted Podman binary not found in ${TMP_DIR}/dist" >&2
    exit 1
fi

mv "${PODMAN_BIN}" "${TARGET_DIR}/podman"
chmod 0755 "${TARGET_DIR}/podman"

echo "Podman successfully installed to ${TARGET_DIR}/podman"
