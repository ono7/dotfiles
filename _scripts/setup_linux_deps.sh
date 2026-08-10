#!/bin/bash

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
  log "Setting up locale..."

  case "$pm" in
  pacman)
    if ! grep -q "^en_US.UTF-8" /etc/locale.gen; then
      sudo sed -i 's/^#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
      sudo locale-gen
    fi
    ;;
  apt | dnf | zypper)
    if command -v locale-gen &>/dev/null; then
      sudo locale-gen "en_US.UTF-8" 2>/dev/null || true
    fi
    ;;
  *)
    log "Skipping automated locale setup for unknown package manager"
    ;;
  esac
}

install_packages_apt() {
  log "Setting up dependencies via APT (Debian/Ubuntu/Mint)"

  sudo apt-add-repository ppa:git-core/ppa -y 2>/dev/null || true
  sudo apt update && sudo apt -y upgrade
  sudo apt remove -y nano 2>/dev/null || true

  sudo apt install -y \
    build-essential procps curl file git screen libssl-dev tree zsh \
    silversearcher-ag fd-find unzip xclip ripgrep stow make sqlite3 \
    wget shfmt shellcheck gron rlwrap pass
}

install_packages_pacman() {
  log "Setting up dependencies via Pacman (Arch Linux)"

  sudo pacman -Syu --noconfirm
  sudo pacman -S --needed --noconfirm \
    base-devel procps curl file git screen usbutils docker foot ctags \
    nvm zoxide starship npm openssl tree zsh the_silver_searcher \
    fd unzip xclip ripgrep stow make sqlite wget shfmt shellcheck \
    rlwrap pass wl-clipboard autotiling xdg-desktop-portal xdg-desktop-portal-wlr

  # Handle AUR helper (yay) for gron
  if ! command -v yay &>/dev/null && ! command -v paru &>/dev/null; then
    log "Installing yay for AUR packages..."
    local temp1="$PWD"
    git clone https://aur.archlinux.org/yay-bin.git ~/yay
    cd ~/yay || exit 1
    makepkg -si --noconfirm
    cd "$temp1" || exit 1
    rm -rf ~/yay
  fi

  if command -v yay &>/dev/null; then
    yay -S --needed --noconfirm gron
  elif command -v paru &>/dev/null; then
    paru -S --needed --noconfirm gron
  else
    log "Warning: gron not installed (requires AUR helper)"
  fi

  sudo pacman -R --noconfirm nano 2>/dev/null || true
}

install_packages_dnf() {
  log "Setting up dependencies via DNF (Fedora/RHEL/CentOS)"

  sudo dnf upgrade -y
  sudo dnf remove -y nano 2>/dev/null || true

  sudo dnf install -y \
    @development-tools procps-ng curl file git screen openssl-devel \
    tree zsh silversearcher-ag fd-find unzip xclip ripgrep stow make \
    sqlite wget shfmt shellcheck rlwrap util-linux-user
}

install_packages_zypper() {
  log "Setting up dependencies via Zypper (openSUSE)"

  sudo zypper refresh
  sudo zypper remove -y nano 2>/dev/null || true

  sudo zypper install -y \
    -t pattern devel_basis
  sudo zypper install -y \
    procps curl file git screen libopenssl-devel tree zsh \
    the_silver_searcher fd unzip xclip ripgrep stow make sqlite3 \
    wget shfmt shellcheck rlwrap pass
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
