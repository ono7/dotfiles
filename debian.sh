#!/usr/bin/env bash
set -euo pipefail

# NOTE(jlima): Sudo elevation directed through /dev/tty to support curl/wget | bash pipelines.
if [ "$EUID" -ne 0 ]; then
    echo "NOTE(jlima): Administrative privileges required. Authenticating with sudo..."
    if [ -e /dev/tty ]; then
        sudo -v < /dev/tty || { echo "NOTE(jlima): Sudo authentication failed."; exit 1; }
    else
        sudo -v || { echo "NOTE(jlima): Sudo authentication failed."; exit 1; }
    fi
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

# NOTE(jlima): Clean up previous install binaries, runtime assets, and config trees.
echo "NOTE(jlima): Purging previous installations and configuration trees..."
NVIM_DIR="/opt/neovim"
sudo rm -rf "$NVIM_DIR"
sudo rm -rf "/root/.config/nvim" "/root/.dotfiles/hooks.json"

if [ "$TARGET_USER" != "root" ]; then
    sudo rm -rf "${TARGET_HOME}/.config/nvim" "${TARGET_HOME}/.dotfiles/hooks.json"
fi

# 1. Install system prerequisites via apt
echo "NOTE(jlima): Installing system prerequisites..."
sudo apt-get update
sudo apt-get install -y ripgrep fd-find curl tar

# NOTE(jlima): Ensure native Debian fd-find binary is linked as fd for telescope compatibility.
if [ -f /usr/bin/fdfind ] && [ ! -e /usr/bin/fd ]; then
    sudo ln -sf /usr/bin/fdfind /usr/bin/fd
fi

# 2. Download and install Neovim to /opt/neovim
sudo mkdir -p "$NVIM_DIR"

echo "NOTE(jlima): Downloading and extracting Neovim stable release to /opt/neovim..."
curl -sL "https://github.com/neovim/neovim/releases/download/stable/nvim-linux-x86_64.tar.gz" | sudo tar -xzC "$NVIM_DIR" --strip-components=1

# 3. Register and activate Neovim using update-alternatives system-wide
for alt in editor vi vim; do
    sudo update-alternatives --install "/usr/bin/$alt" "$alt" "/opt/neovim/bin/nvim" 150
    sudo update-alternatives --set "$alt" "/opt/neovim/bin/nvim"
done

# 4. Deploy fresh configurations for root
echo "NOTE(jlima): Deploying configurations for root..."
ROOT_CONFIG="/root/.config/nvim"
ROOT_DOTFILES="/root/.dotfiles"
sudo mkdir -p "$ROOT_CONFIG" "$ROOT_DOTFILES"
sudo curl -sL "https://raw.githubusercontent.com/ono7/dotfiles/refs/heads/main/vim/.vimrc_min.lua" -o "$ROOT_CONFIG/init.lua"
sudo curl -sL "https://raw.githubusercontent.com/ono7/dotfiles/refs/heads/main/hooks.json" -o "$ROOT_DOTFILES/hooks.json" 2>/dev/null || true

# 5. Deploy fresh configurations for invoking sudo user (if not already root)
if [ "$TARGET_USER" != "root" ]; then
    echo "NOTE(jlima): Deploying configurations for invoking user '${TARGET_USER}'..."
    USER_CONFIG="${TARGET_HOME}/.config/nvim"
    USER_DOTFILES="${TARGET_HOME}/.dotfiles"

    sudo -u "$TARGET_USER" mkdir -p "$USER_CONFIG" "$USER_DOTFILES"
    sudo -u "$TARGET_USER" curl -sL "https://raw.githubusercontent.com/ono7/dotfiles/refs/heads/main/vim/.vimrc_min.lua" -o "$USER_CONFIG/init.lua"
    sudo -u "$TARGET_USER" curl -sL "https://raw.githubusercontent.com/ono7/dotfiles/refs/heads/main/hooks.json" -o "$USER_DOTFILES/hooks.json" 2>/dev/null || true
fi

echo "NOTE(jlima): Neovim system-wide installation and configuration completed successfully."
/usr/bin/nvim --version
