#!/usr/bin/env bash
set -euo pipefail

# NOTE(jlima): Distinctive ANSI-highlighted banner helper to cut through verbose package manager/curl output.
log_step() {
    printf "\n\033[1;36m==>\033[0m \033[1m%s\033[0m\n" "$1"
}

log_step "Authenticating administrative privileges..."
if [ "$EUID" -ne 0 ]; then
    if [ -e /dev/tty ]; then
        sudo -v < /dev/tty || { echo "Sudo authentication failed."; exit 1; }
    else
        sudo -v || { echo "Sudo authentication failed."; exit 1; }
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

log_step "Target environment: '${TARGET_USER}' (home: ${TARGET_HOME})"

# 1. Purge previous Neovim binaries, configs, and all XDG runtime/data namespaces
log_step "Purging previous Neovim binaries, ~/.config/nvim, and runtime data trees..."
NVIM_DIR="/opt/neovim"
sudo rm -rf "$NVIM_DIR"

# NOTE(jlima): Wipe ~/.config/nvim completely alongside dotfiles hooks and runtime namespaces.
sudo rm -rf /root/.config/nvim /root/.dotfiles/hooks.json
sudo rm -rf /root/.local/share/nvim /root/.local/state/nvim /root/.cache/nvim

if [ "$TARGET_USER" != "root" ]; then
    sudo rm -rf "${TARGET_HOME}/.config/nvim" "${TARGET_HOME}/.dotfiles/hooks.json"
    sudo rm -rf "${TARGET_HOME}/.local/share/nvim" "${TARGET_HOME}/.local/state/nvim" "${TARGET_HOME}/.cache/nvim"
fi

# 2. Install system prerequisites via apt
log_step "Installing system prerequisites via apt (ripgrep, fd-find, curl, tar, git)..."
sudo apt-get update
# NOTE(jlima): Ensure git is explicitly present for vim.pack cloning and lock reconciliation.
sudo apt-get install -y ripgrep fd-find curl tar git

# NOTE(jlima): Ensure native Debian fd-find binary is linked as fd for telescope compatibility.
if [ -f /usr/bin/fdfind ] && [ ! -e /usr/bin/fd ]; then
    log_step "Symlinking /usr/bin/fdfind -> /usr/bin/fd..."
    sudo ln -sf /usr/bin/fdfind /usr/bin/fd
fi

# 3. Download and install Neovim to /opt/neovim
log_step "Downloading and extracting Neovim stable to /opt/neovim..."
sudo mkdir -p "$NVIM_DIR"
curl -sL "https://github.com/neovim/neovim/releases/download/stable/nvim-linux-x86_64.tar.gz" | sudo tar -xzC "$NVIM_DIR" --strip-components=1

# 4. Register and activate Neovim using update-alternatives system-wide
log_step "Configuring update-alternatives (editor, vi, vim) -> /opt/neovim/bin/nvim..."
for alt in editor vi vim; do
    sudo update-alternatives --install "/usr/bin/$alt" "$alt" "/opt/neovim/bin/nvim" 150
    sudo update-alternatives --set "$alt" "/opt/neovim/bin/nvim"
done

# 5. Deploy fresh configurations for root
log_step "Deploying Lua configuration and runner hooks for root..."
ROOT_CONFIG="/root/.config/nvim"
ROOT_DOTFILES="/root/.dotfiles"
sudo mkdir -p "$ROOT_CONFIG" "$ROOT_DOTFILES"
sudo curl -sL "https://raw.githubusercontent.com/ono7/dotfiles/refs/heads/main/vim/.vimrc_min.lua" -o "$ROOT_CONFIG/init.lua"
sudo curl -sL "https://raw.githubusercontent.com/ono7/dotfiles/refs/heads/main/hooks.json" -o "$ROOT_DOTFILES/hooks.json" 2>/dev/null || true

# 6. Deploy fresh configurations for invoking sudo user (if not already root)
if [ "$TARGET_USER" != "root" ]; then
    log_step "Deploying Lua configuration and runner hooks for '${TARGET_USER}'..."
    USER_CONFIG="${TARGET_HOME}/.config/nvim"
    USER_DOTFILES="${TARGET_HOME}/.dotfiles"

    sudo -u "$TARGET_USER" mkdir -p "$USER_CONFIG" "$USER_DOTFILES"
    sudo -u "$TARGET_USER" curl -sL "https://raw.githubusercontent.com/ono7/dotfiles/refs/heads/main/vim/.vimrc_min.lua" -o "$USER_CONFIG/init.lua"
    sudo -u "$TARGET_USER" curl -sL "https://raw.githubusercontent.com/ono7/dotfiles/refs/heads/main/hooks.json" -o "$USER_DOTFILES/hooks.json" 2>/dev/null || true
fi

log_step "Bootstrap complete. Verifying /usr/bin/nvim version..."
/usr/bin/nvim --version
