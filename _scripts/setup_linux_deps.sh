#!/usr/bin/env bash

set -euo pipefail

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
    sudo apt-get install -y locales 2>/dev/null || true
    if command -v locale-gen &>/dev/null; then
      sudo locale-gen "en_US.UTF-8" 2>/dev/null || true
      sudo update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 2>/dev/null || true
    fi
    ;;
  dnf)
    # Fedora uses glibc language packs instead of locale-gen
    sudo dnf install -y glibc-langpack-en 2>/dev/null || true
    ;;
  zypper)
    sudo zypper install -y glibc-locale 2>/dev/null || true
    ;;
  *)
    log "Skipping automated locale setup for unknown package manager"
    ;;
  esac
}

install_packages_apt() {
  log "Setting up dependencies via APT (Debian/Ubuntu/Mint)"

  sudo apt-add-repository ppa:git-core/ppa -y 2>/dev/null || true
  sudo apt-get update && sudo apt-get -y upgrade
  sudo apt-get remove -y nano 2>/dev/null || true

  sudo apt-get install -y \
    build-essential procps curl file git screen \
    libssl-dev libncurses-dev gettext \
    python3-dev libperl-dev \
    tree zsh silversearcher-ag fd-find unzip xclip wl-clipboard ripgrep stow make sqlite3 \
    wget shfmt shellcheck gron rlwrap pass golang-go

  sudo apt-get install -y tree-sitter-cli 2>/dev/null || true
  sudo apt-get install -y eza 2>/dev/null || true
}

install_packages_pacman() {
  log "Setting up dependencies via Pacman (Arch Linux)"

  sudo pacman -Syu --noconfirm
  sudo pacman -R --noconfirm nano 2>/dev/null || true

  sudo pacman -S --needed --noconfirm \
    base-devel cmake ninja procps-ng curl file git screen usbutils \
    openssl ncurses gettext python perl \
    tree zsh the_silver_searcher fd unzip xclip wl-clipboard ripgrep stow make sqlite \
    wget shfmt shellcheck rlwrap pass go \
    zoxide starship npm \
    neovim neovide tree-sitter-cli eza
}

install_packages_dnf() {
  log "Setting up dependencies via DNF (Fedora/RHEL)"

  sudo dnf upgrade -y
  sudo dnf remove -y nano 2>/dev/null || true

  # Base tools, compile headers for Vim/Neovim, and CLI utilities
  sudo dnf install -y \
    @development-tools \
    gcc gcc-c++ make cmake ninja-build \
    procps-ng curl file git screen \
    openssl-devel ncurses-devel gettext \
    python3-devel perl-devel perl-ExtUtils-Embed \
    tree zsh the_silver_searcher fd-find unzip xclip wl-clipboard ripgrep stow \
    sqlite wget shfmt shellcheck rlwrap pass util-linux-user golang

  # keyd hardware remapper
  sudo dnf -y copr enable alternateved/keyd
  sudo dnf -y install keyd
}

install_packages_zypper() {
  log "Setting up dependencies via Zypper (openSUSE)"

  sudo zypper refresh
  sudo zypper remove -y nano 2>/dev/null || true

  sudo zypper install -y -t pattern devel_basis
  sudo zypper install -y \
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
