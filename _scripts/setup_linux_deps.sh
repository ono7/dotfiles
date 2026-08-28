#!/usr/bin/env bash

set -euo pipefail

# Force debconf/APT and CLI frontends into non-interactive mode globally
export DEBIAN_FRONTEND=noninteractive
export NEEDRESTART_MODE=a

log() {
  printf '\n%s - %s\n\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$*"
}

detect_pkg_manager() {
  if command -v apt-get &>/dev/null; then
    echo "apt"
  elif command -v pacman &>/dev/null; then
    echo "pacman"
  elif command -v dnf &>/dev/null; then
    echo "dnf"
  elif command -v zypper &>/dev/null; then
    echo "zypper"
  elif command -v apk &>/dev/null; then
    echo "apk"
  else
    echo "unknown"
  fi
}

setup_locale() {
  local pm="$1"
  log "Setting up locale (en_US.UTF-8)..."

  case "$pm" in
  pacman)
    if ! grep -q "^en_US.UTF-8" /etc/locale.gen 2>/dev/null; then
      sudo sed -i 's/^#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
      sudo locale-gen
    fi
    ;;
  apt)
    sudo DEBIAN_FRONTEND=noninteractive apt-get install -y -qq locales 2>/dev/null || true
    if command -v locale-gen &>/dev/null; then
      sudo locale-gen "en_US.UTF-8" 2>/dev/null || true
      sudo update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 2>/dev/null || true
    fi
    ;;
  dnf)
    sudo dnf install -y glibc-langpack-en 2>/dev/null || true
    ;;
  zypper)
    sudo zypper --non-interactive install -y glibc-locale 2>/dev/null || true
    ;;
  *)
    log "Skipping automated locale setup for unknown package manager"
    ;;
  esac
}

install_packages_apt() {
  log "Setting up dependencies via APT (Debian/Ubuntu/Mint)"

  local apt_opts=(
    -y
    -o Dpkg::Options::="--force-confdef"
    -o Dpkg::Options::="--force-confold"
  )

  sudo DEBIAN_FRONTEND=noninteractive apt-add-repository ppa:git-core/ppa -y 2>/dev/null || true
  sudo DEBIAN_FRONTEND=noninteractive apt-get update
  sudo DEBIAN_FRONTEND=noninteractive apt-get "${apt_opts[@]}" upgrade
  sudo DEBIAN_FRONTEND=noninteractive apt-get "${apt_opts[@]}" remove nano 2>/dev/null || true

  sudo DEBIAN_FRONTEND=noninteractive apt-get "${apt_opts[@]}" install \
    build-essential procps curl file git screen \
    libssl-dev libncurses-dev gettext \
    python3-dev libperl-dev \
    tree zsh silversearcher-ag fd-find unzip xclip wl-clipboard ripgrep stow make sqlite3 \
    wget shfmt shellcheck gron rlwrap pass golang-go

  sudo DEBIAN_FRONTEND=noninteractive apt-get "${apt_opts[@]}" install tree-sitter-cli 2>/dev/null || true
  sudo DEBIAN_FRONTEND=noninteractive apt-get "${apt_opts[@]}" install eza 2>/dev/null || true
}

install_packages_pacman() {
  log "Setting up dependencies via Pacman (Arch Linux)"

  sudo pacman -Syu --noconfirm --ask 4
  sudo pacman -R --noconfirm nano 2>/dev/null || true

  # --ask 4 automatically selects default choices for package provider prompts and clean builds
  sudo pacman -S --needed --noconfirm --ask 4 \
    base-devel cmake ninja procps-ng curl file git screen usbutils \
    openssl ncurses gettext python perl \
    tree zsh the_silver_searcher fd unzip xclip wl-clipboard ripgrep stow make sqlite \
    wget shfmt shellcheck rlwrap pass go \
    zoxide starship npm \
    neovim neovide tree-sitter-cli eza
}

install_packages_dnf() {
  log "Setting up dependencies via DNF (Fedora/RHEL)"

  sudo dnf upgrade -y --setopt=install_weak_deps=False
  sudo dnf remove -y nano 2>/dev/null || true

  # Base tools, compile headers, and CLI utilities
  sudo dnf install -y \
    @development-tools \
    gcc gcc-c++ make cmake ninja-build \
    procps-ng curl file git screen \
    openssl-devel ncurses-devel gettext \
    python3-devel perl-devel perl-ExtUtils-Embed \
    tree zsh the_silver_searcher fd-find unzip xclip wl-clipboard ripgrep stow \
    sqlite wget shfmt shellcheck rlwrap pass util-linux-user golang

  # keyd hardware remapper (-y flag passed to copr enable to avoid repo confirmation prompt)
  sudo dnf copr enable -y alternateved/keyd || true
  sudo dnf install -y keyd
}

install_packages_zypper() {
  log "Setting up dependencies via Zypper (openSUSE)"

  # --non-interactive and auto-agree flags prevent prompt hangs
  sudo zypper --non-interactive refresh
  sudo zypper --non-interactive remove -y nano 2>/dev/null || true

  sudo zypper --non-interactive install -y --auto-agree-with-licenses -t pattern devel_basis
  sudo zypper --non-interactive install -y --auto-agree-with-licenses \
    procps curl file git screen \
    libopenssl-devel ncurses-devel gettext-tools \
    python3-devel perl-devel perl-ExtUtils-Embed \
    tree zsh the_silver_searcher fd unzip xclip wl-clipboard ripgrep stow make sqlite3 \
    wget shfmt shellcheck rlwrap pass go
}

main() {
  log "$0"

  if [ "$(uname)" != 'Linux' ]; then
    log 'I only run on Linux.'
    exit 1
  fi

  local pm
  pm=$(detect_pkg_manager)
  log "Detected package manager: $pm"

  setup_locale "$pm"

  case "$pm" in
  apt)
    install_packages_apt
    ;;
  pacman)
    install_packages_pacman
    ;;
  dnf)
    install_packages_dnf
    ;;
  zypper)
    install_packages_zypper
    ;;
  *)
    log "Unsupported package manager or unknown distribution."
    log "Please install core developer tools manually."
    exit 1
    ;;
  esac

  log "Dependencies installation completed successfully."
}

main "$@"
