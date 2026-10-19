#!/usr/bin/env bash
set -euo pipefail

# NOTE(jlima): Determine target user and home directory correctly whether run directly or via sudo.
if [ "$EUID" -eq 0 ] && [ -n "${SUDO_USER:-}" ]; then
    TARGET_USER="$SUDO_USER"
    TARGET_HOME="$(getent passwd "$SUDO_USER" | cut -d: -f6)"
    HAS_ROOT=true
elif [ "$EUID" -eq 0 ]; then
    TARGET_USER="root"
    TARGET_HOME="/root"
    HAS_ROOT=true
elif command -v sudo >/dev/null 2>&1 && sudo -n true 2>/dev/null; then
    TARGET_USER="${USER:-$(whoami)}"
    TARGET_HOME="$HOME"
    HAS_ROOT=true
else
    TARGET_USER="${USER:-$(whoami)}"
    TARGET_HOME="$HOME"
    HAS_ROOT=false
fi

echo "NOTE(jlima): Bootstrapping Neovim for user '${TARGET_USER}' (Root/Sudo: ${HAS_ROOT})"

if [ "$HAS_ROOT" = true ]; then
    RUN_CMD=""
    if [ "$EUID" -ne 0 ]; then
        RUN_CMD="sudo"
    fi

    echo "NOTE(jlima): Installing system prerequisites via apt..."
    $RUN_CMD apt-get update
    $RUN_CMD apt-get install -y ripgrep fd-find curl tar

    # NOTE(jlima): Ensure native Debian fd-find binary is linked as fd for telescope compatibility.
    if [ -f /usr/bin/fdfind ] && [ ! -e /usr/bin/fd ]; then
        $RUN_CMD ln -sf /usr/bin/fdfind /usr/bin/fd
    fi

    NVIM_DIR="/opt/neovim"
    $RUN_CMD rm -rf "$NVIM_DIR"
    $RUN_CMD mkdir -p "$NVIM_DIR"

    echo "NOTE(jlima): Downloading and extracting Neovim stable release to /opt/neovim..."
    curl -sL "https://github.com/neovim/neovim/releases/download/stable/nvim-linux-x86_64.tar.gz" | $RUN_CMD tar -xzC "$NVIM_DIR" --strip-components=1

    # NOTE(jlima): Register and activate Neovim using update-alternatives for system-wide binaries.
    for alt in editor vi vim; do
        $RUN_CMD update-alternatives --install "/usr/bin/$alt" "$alt" "/opt/neovim/bin/nvim" 150
        $RUN_CMD update-alternatives --set "$alt" "/opt/neovim/bin/nvim"
    done
else
    echo "NOTE(jlima): Installing to user-local directory ~/.local/bin..."
    LOCAL_BIN="${TARGET_HOME}/.local/bin"
    NVIM_DIR="${TARGET_HOME}/.local/neovim"
    mkdir -p "$LOCAL_BIN" "$NVIM_DIR"

    echo "NOTE(jlima): Downloading and extracting Neovim stable release locally..."
    curl -sL "https://github.com/neovim/neovim/releases/download/stable/nvim-linux-x86_64.tar.gz" | tar -xzC "$NVIM_DIR" --strip-components=1

    ln -sf "$NVIM_DIR/bin/nvim" "$LOCAL_BIN/nvim"
    echo "NOTE(jlima): Ensure ${LOCAL_BIN} is present in your PATH."
fi

# Deploy Neovim configuration directories and fetch init.lua from raw GitHub URL
CONFIG_HOME="${TARGET_HOME}/.config/nvim"
DOTFILES_HOME="${TARGET_HOME}/.dotfiles"
mkdir -p "$CONFIG_HOME" "$DOTFILES_HOME"

echo "NOTE(jlima): Downloading init.lua from dotfiles repository..."
curl -sL "https://raw.githubusercontent.com/ono7/dotfiles/refs/heads/main/vim/.vimrc_min.lua" -o "$CONFIG_HOME/init.lua"

# Correct ownership if script ran with elevated privileges for a standard user account
if [ "$EUID" -eq 0 ] && [ "$TARGET_USER" != "root" ]; then
    chown -R "$TARGET_USER:$TARGET_USER" "$CONFIG_HOME" "$DOTFILES_HOME"
fi

echo "NOTE(jlima): Neovim bootstrap completed successfully."
nvim --version || "${TARGET_HOME}/.local/bin/nvim" --version

