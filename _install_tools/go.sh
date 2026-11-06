# Detect architecture
ARCH="$(uname -m)"
case "${ARCH}" in
  x86_64) GOARCH="amd64" ;;
  arm64)  GOARCH="arm64" ;;
  *) echo "Unsupported architecture: ${ARCH}"; exit 1 ;;
esac

# Query latest stable version and download
GO_VER="$(curl -s 'https://go.dev/VERSION?m=text' | head -n1)"
INSTALL_DIR="${HOME}/.local"
mkdir -p "${INSTALL_DIR}"

curl -fSL "https://go.dev/dl/${GO_VER}.darwin-${GOARCH}.tar.gz" -o "/tmp/${GO_VER}.tar.gz"

# NOTE(jlima): Purge existing root before extraction to avoid stale artifacts
rm -rf "${INSTALL_DIR}/go"
tar -C "${INSTALL_DIR}" -xzf "/tmp/${GO_VER}.tar.gz"
rm -f "/tmp/${GO_VER}.tar.gz"
