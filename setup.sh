#!/usr/bin/env bash
set -euo pipefail

# NOTE(jlima): Prompt for sudo upfront to capture invoking user and ensure administrative rights.
if [ "$EUID" -ne 0 ]; then
    echo "NOTE(jlima): Administrative privileges required. Please authenticate with sudo."
    sudo -v || { echo "NOTE(jlima): Sudo authentication failed."; exit 1; }
fi

# NOTE(jlima): Capture invoking user and target home directories accurately.
INVOKING_USER="${SUDO_USER:-$(whoami)}"
if [ "$INVOKING_USER" = "root" ]; then
    TARGET_USER="root"
    TARGET_HOME="/root"
else
    TARGET_USER="$INVOKING_USER"
    TARGET_HOME="$(getent passwd "$INVOKING_USER" | cut -d: -f6)"
fi

echo "NOTE(jlima): Bootstrapping Neovim system-wide as root for invoking user: '${TARGET_USER}'"

# Install system prerequisites via apt
echo "NOTE(jlima): Installing system prerequisites..."
apt-get update
apt-get install -y ripgrep fd-find curl tar

# NOTE(jlima): Ensure native Debian fd-find binary is linked as fd for telescope compatibility.
if [ -f /usr/bin/fdfind ] && [ ! -e /usr/bin/fd ]; then
    ln -sf /usr/bin/fdfind /usr/bin/fd
fi

# Download and install Neovim to /opt/neovim
NVIM_DIR="/opt/neovim"
rm -rf "$NVIM_DIR"
mkdir -p "$NVIM_DIR"

echo "NOTE(jlima): Downloading and extracting Neovim stable release to /opt/neovim..."
curl -sL "https://github.com/neovim/neovim/releases/download/stable/nvim-linux-x86_64.tar.gz" | tar -xzC "$NVIM_DIR" --strip-components=1

# Register and activate Neovim using update-alternatives
for alt in editor vi vim; do
    update-alternatives --install "/usr/bin/$alt" "$alt" "/opt/neovim/bin/nvim" 150
    update-alternatives --set "$alt" "/opt/neovim/bin/nvim"
done

# Fully configure Neovim for root
ROOT_CONFIG="/root/.config/nvim"
ROOT_DOTFILES="/root/.dotfiles"
mkdir -p "$ROOT_CONFIG" "$ROOT_DOTFILES"

echo "NOTE(jlima): Deploying configurations for root..."
curl -sL "https://raw.githubusercontent.com/ono7/dotfiles/refs/heads/main/vim/.vimrc_min.lua" -o "$ROOT_CONFIG/init.lua"
curl -sL "https://raw.githubusercontent.com/ono7/dotfiles/refs/heads/main/hooks.json" -o "$ROOT_DOTFILES/hooks.json" 2>/dev/null || true

# Configure for the invoking non-root user if applicable
if [ "$TARGET_USER" != "root" ]; then
    read -rp "NOTE(jlima): Do you also want to fully configure Neovim for user '${TARGET_USER}'? [Y/n]: " INSTALL_USER_CONFIG
    # Default to Yes if just pressing enter
    INSTALL_USER_CONFIG="${INSTALL_USER_CONFIG:-Y}"

    if [[ "$INSTALL_USER_CONFIG" =~ ^[Yy]$ ]]; then
        USER_CONFIG="${TARGET_HOME}/.config/nvim"
        USER_DOTFILES="${TARGET_HOME}/.dotfiles"

        # NOTE(jlima): Create directories and immediately assign correct ownership before downloading files.
        sudo -u "$TARGET_USER" mkdir -p "$USER_CONFIG" "$USER_DOTFILES"

        echo "NOTE(jlima): Deploying configurations for ${TARGET_USER}..."
        sudo -u "$TARGET_USER" curl -sL "https://raw.githubusercontent.com/ono7/dotfiles/refs/heads/main/vim/.vimrc_min.lua" -o "$USER_CONFIG/init.lua"
        sudo -u "$TARGET_USER" curl -sL "https://raw.githubusercontent.com/ono7/dotfiles/refs/heads/main/hooks.json" -o "$USER_DOTFILES/hooks.json" 2>/dev/null || true

        echo "NOTE(jlima): User configuration completed for '${TARGET_USER}'."
    fi
fi

echo "NOTE(jlima): Neovim system-wide bootstrap completed successfully."
nvim --version
