#!/usr/bin/env bash
set -euo pipefail

# NOTE(jlima): Self-contained GNU wget build targeting ~/.local/bin with static OpenSSL linkage
WORK_DIR="$(mktemp -d -t user_wget_XXXXXX)"
PREFIX="${HOME}/.local"
BINDIR="${PREFIX}/bin"
MANDIR="${PREFIX}/share/man/man1"
STAGE_SSL="${WORK_DIR}/ssl_stage"

WGET_VERSION="1.24.5"
OPENSSL_VERSION="3.3.2"

WGET_URL="https://ftp.gnu.org/gnu/wget/wget-${WGET_VERSION}.tar.gz"
OPENSSL_URL="https://github.com/openssl/openssl/releases/download/openssl-${OPENSSL_VERSION}/openssl-${OPENSSL_VERSION}.tar.gz"

CPUS="$(sysctl -n hw.ncpu 2>/dev/null || echo 4)"

trap 'rm -rf "${WORK_DIR}"' EXIT

mkdir -p "${BINDIR}" "${MANDIR}" "${STAGE_SSL}"

# ---------------------------------------------------------------------------
# 1. Build Isolated Static OpenSSL (Dependency for HTTPS)
# ---------------------------------------------------------------------------
echo "==> Fetching OpenSSL ${OPENSSL_VERSION}..."
curl -fsSL "${OPENSSL_URL}" | tar -xz -C "${WORK_DIR}"

echo "==> Building OpenSSL for static linkage..."
cd "${WORK_DIR}/openssl-${OPENSSL_VERSION}"

# NOTE(jlima): Build strictly static libraries to avoid runtime dynamic linker rpath issues
./Configure \
  darwin64-arm64-cc \
  no-shared \
  no-tests \
  --prefix="${STAGE_SSL}" \
  --openssldir="${STAGE_SSL}/ssl"

make -j"${CPUS}"
make install_sw

# ---------------------------------------------------------------------------
# 2. Build GNU wget
# ---------------------------------------------------------------------------
echo "==> Fetching GNU wget ${WGET_VERSION}..."
curl -fsSL "${WGET_URL}" | tar -xz -C "${WORK_DIR}"

echo "==> Configuring and compiling wget..."
cd "${WORK_DIR}/wget-${WGET_VERSION}"

# NOTE(jlima): Point pkg-config and compiler flags strictly to the staged static OpenSSL
OPENSSL_CFLAGS="-I${STAGE_SSL}/include" \
OPENSSL_LIBS="-L${STAGE_SSL}/lib -lssl -lcrypto" \
./configure \
  --prefix="${PREFIX}" \
  --disable-nls \
  --disable-pcre \
  --disable-pcre2 \
  --with-ssl=openssl \
  --with-libssl-prefix="${STAGE_SSL}"

make -j"${CPUS}"

# NOTE(jlima): Bypass full recursive make install to eliminate texinfo/infodir overhead
install -m 0755 src/wget "${BINDIR}/wget"
install -m 0644 doc/wget.1 "${MANDIR}/wget.1"

echo "==> wget installed successfully:"
"${BINDIR}/wget" --version | head -n 2
