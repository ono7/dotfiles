#!/bin/bash

log() {
  printf '\n%s - %s\n\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$*"
}

detect_distro() {
  if [ -f /etc/os-release ]; then
    . /etc/os-release
    echo "$ID"
  elif [ -f /etc/arch-release ]; then
    echo "arch"
  elif [ -f /etc/debian_version ]; then
    echo "debian"
  else
    echo "unknown"
  fi
}

install_arch_packages() {
  log "setting up Arch Linux dependencies (pacman)"

  # Update package database
  sudo pacman -Sy

  # Install base development tools and dependencies
  sudo pacman -S --needed --noconfirm base-devel procps curl file git

  # Install additional tools
  sudo pacman -S --needed --noconfirm docker foot ctags nvm zoxide starship npm
  sudo pacman -S --needed --noconfirm openssl tree zsh the_silver_searcher \
    fd unzip xclip ripgrep stow make sqlite wget shfmt shellcheck \
    rlwrap pass wl-clipboard
  sudo pacman -S autotiling xdg-desktop-portal xdg-desktop-portal-wlr --needed

  temp1=$PWD
  git clone https://aur.archlinux.org/yay-bin.git ~/yay
  cd ~/yay
  sudo pacman -S base-devel
  makepkg -si
  cd $temp1
  rm -rf ~/yay

  # Install gron from AUR (if yay is available) or skip with warning
  if command -v yay &>/dev/null; then
    yay -S --needed --noconfirm gron
  elif command -v paru &>/dev/null; then
    paru -S --needed --noconfirm gron
  else
    log "Warning: gron not installed (requires AUR helper like yay or paru)"
  fi

  # Remove nano if installed
  sudo pacman -R --noconfirm nano 2>/dev/null || true
}

install_debian_packages() {
  log "setting up Debian/Ubuntu dependencies (apt)"

  # Add git PPA for latest git version
  sudo apt-add-repository ppa:git-core/ppa -y
  sudo apt update
  sudo apt -y upgrade

  # Remove nano
  sudo apt remove -y nano

  # Install base development tools
  sudo apt install -y build-essential procps curl file git

  # Install additional tools
  sudo apt install -y libssl-dev tree zsh silversearcher-ag \
    fd-find unzip xclip ripgrep stow make sqlite3 wget shfmt shellcheck gron \
    rlwrap pass
}

setup_locale() {
  local distro="$1"

  case "$distro" in
  arch | manjaro | endeavouros)
    log "setting up locale (Arch)"
    # Arch uses different locale setup
    if ! grep -q "^en_US.UTF-8" /etc/locale.gen; then
      sudo sed -i 's/^#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
      sudo locale-gen
    fi
    ;;
  ubuntu | debian | pop | mint)
    log "setting up locale (Debian/Ubuntu)"
    sudo locale-gen "en_US.UTF-8"
    ;;
  *)
    log "Unknown distribution, skipping locale setup"
    ;;
  esac
}

main() {
  log "$0"

  if [ "$(uname)" != 'Linux' ]; then
    log 'I only run on Linux..'
    exit 1
  fi

  local distro
  distro=$(detect_distro)
  log "Detected distribution: $distro"

  setup_locale "$distro"

  case "$distro" in
  arch | manjaro | endeavouros)
    install_arch_packages
    ;;
  ubuntu | debian | pop | mint)
    install_debian_packages
    ;;
  *)
    log "Unsupported distribution: $distro"
    log "This script supports Arch Linux and Debian/Ubuntu-based distributions"
    exit 1
    ;;
  esac

  log "Dependencies installation completed for $distro"
}

# Uncommented sections from your original script for reference:
# You can uncomment and adapt these as needed

# install_python() {
#   local distro="$1"
#   case "$distro" in
#     arch|manjaro|endeavouros)
#       sudo pacman -S --needed --noconfirm python python-pip
#       ;;
#     ubuntu|debian|pop|mint)
#       sudo apt install python3 python3-pip python3-venv socat -y
#       # For specific Python versions:
#       # sudo add-apt-repository ppa:deadsnakes/ppa
#       # sudo apt update
#       # sudo apt install python3.11 -y
#       ;;
#   esac
# }

# install_snap_packages() {
#   if type snap &>/dev/null; then
#     log "installing snap packages"
#     sudo snap install go --classic
#     sudo snap install universal-ctags btop
#     sudo snap install --edge starship
#   fi
# }

# install_delta() {
#   log "installing delta git pager"
#   ARCH=$(uname -m)
#   DELTA_VERSION="0.18.1"
#
#   mkdir -p ~/local/bin
#   rm -rf ~/local/bin/delta
#
#   rm -f delta-${DELTA_VERSION}-${ARCH}-unknown-linux-gnu.tar.gz
#   curl -sL -O https://github.com/dandavison/delta/releases/download/${DELTA_VERSION}/delta-${DELTA_VERSION}-${ARCH}-unknown-linux-gnu.tar.gz
#
#   tar xzvf delta-${DELTA_VERSION}-${ARCH}-unknown-linux-gnu.tar.gz
#   cp delta-${DELTA_VERSION}-${ARCH}-unknown-linux-gnu/delta ~/local/bin/delta
#   rm -rf delta-${DELTA_VERSION}-${ARCH}-unknown-linux-gnu*
#
#   if [[ -f ~/local/bin/delta ]]; then
#     log "delta installed successfully"
#   else
#     log "delta installation failed"
#   fi
# }

# install_direnv() {
#   log "installing direnv"
#   curl -sfL https://direnv.net/install.sh | bash
# }

main "$@"
