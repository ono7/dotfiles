#!/usr/bin/env bash
set -euo pipefail

# NOTE(jlima): Prompt user interactively to select installation target domain.
read -rp "Install Neovim system-wide or user-only? (s/u) [default: u]: " INSTALL_MODE
INSTALL_MODE="${INSTALL_MODE:-u}"

if [[ "$INSTALL_MODE" =~ ^[Ss]$ ]]; then
    # ==========================================
    # System-wide Installation
    # ==========================================
    # NOTE(jlima): Sudo elevation deferred strictly to system branch to avoid root leaks during user install.
    if [ "$EUID" -ne 0 ]; then
        echo "NOTE(jlima): Administrative privileges required. Please authenticate with sudo."
        sudo -v || { echo "NOTE(jlima): Sudo authentication failed."; exit 1; }
    fi

    INVOKING_USER="${SUDO_USER:-$(whoami)}"
    if [ "$INVOKING_USER" = "root" ]; then
        TARGET_USER="root"
        TARGET_HOME="/root"
    else
        TARGET_USER="$INVOKING_USER"
        TARGET_HOME="$(getent passwd "$INVOKING_USER" | cut -d: -f6)"
    fi

    echo "NOTE(jlima): Bootstrapping Neovim system-wide as root for invoking user: '${TARGET_USER}'"

    # NOTE(jlima): Purge existing system install directory and configuration paths before re-deploying.
    echo "NOTE(jlima): Cleaning up prior system and user configurations..."
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

    # 4. Deploy configurations for root
    echo "NOTE(jlima): Deploying fresh configurations for root..."
    ROOT_CONFIG="/root/.config/nvim"
    ROOT_DOTFILES="/root/.dotfiles"
    sudo mkdir -p "$ROOT_CONFIG" "$ROOT_DOTFILES"
    sudo curl -sL "https://raw.githubusercontent.com/ono7/dotfiles/refs/heads/main/vim/.vimrc_min.lua" -o "$ROOT_CONFIG/init.lua"
    sudo curl -sL "https://raw.githubusercontent.com/ono7/dotfiles/refs/heads/main/hooks.json" -o "$ROOT_DOTFILES/hooks.json" 2>/dev/null || true

    # 5. Deploy configurations for invoking sudo user (if not already root)
    if [ "$TARGET_USER" != "root" ]; then
        echo "NOTE(jlima): Deploying fresh configurations for invoking user '${TARGET_USER}'..."
        USER_CONFIG="${TARGET_HOME}/.config/nvim"
        USER_DOTFILES="${TARGET_HOME}/.dotfiles"

        sudo -u "$TARGET_USER" mkdir -p "$USER_CONFIG" "$USER_DOTFILES"
        sudo -u "$TARGET_USER" curl -sL "https://raw.githubusercontent.com/ono7/dotfiles/refs/heads/main/vim/.vimrc_min.lua" -o "$USER_CONFIG/init.lua"
        sudo -u "$TARGET_USER" curl -sL "https://raw.githubusercontent.com/ono7/dotfiles/refs/heads/main/hooks.json" -o "$USER_DOTFILES/hooks.json" 2>/dev/null || true
    fi

    echo "NOTE(jlima): Neovim system-wide installation completed successfully."
    /usr/bin/nvim --version

elif [[ "$INSTALL_MODE" =~ ^[Uu]$ ]]; then
    # ==========================================
    # User-only Installation (~/.local)
    # ==========================================
    if [ "$EUID" -eq 0 ]; then
        echo "NOTE(jlima): User install mode selected while running as root; install targets /root/.local."
    fi

    USER_PREFIX="${HOME}/.local"
    USER_BIN="${USER_PREFIX}/bin"
    USER_CONFIG="${HOME}/.config/nvim"
    USER_DOTFILES="${HOME}/.dotfiles"

    # NOTE(jlima): Explicitly remove previous config directory, runner hooks, and local bin entries.
    echo "NOTE(jlima): Cleaning up prior user configs and binaries..."
    rm -rf "$USER_CONFIG"
    rm -f "${USER_DOTFILES}/hooks.json"
    rm -f "${USER_BIN}/nvim" "${USER_BIN}/vim" "${USER_BIN}/vi"
    rm -rf "${USER_PREFIX}/lib/nvim" "${USER_PREFIX}/share/nvim"

    mkdir -p "$USER_BIN" "$USER_CONFIG" "$USER_DOTFILES"

    # NOTE(jlima): Extract archive root directly to ~/.local so bin, lib, and share overlay cleanly without nested paths.
    echo "NOTE(jlima): Downloading and extracting Neovim tarball directly into ${USER_PREFIX}..."
    curl -sL "https://github.com/neovim/neovim/releases/download/stable/nvim-linux-x86_64.tar.gz" | tar -xzC "$USER_PREFIX" --strip-components=1

    # NOTE(jlima): Symlink vim/vi in ~/.local/bin to default to nvim without updating shell rc files.
    ln -sf "${USER_BIN}/nvim" "${USER_BIN}/vim"
    ln -sf "${USER_BIN}/nvim" "${USER_BIN}/vi"

    # Deploy user configurations
    echo "NOTE(jlima): Deploying fresh user-level configurations..."
    curl -sL "https://raw.githubusercontent.com/ono7/dotfiles/refs/heads/main/vim/.vimrc_min.lua" -o "$USER_CONFIG/init.lua"
    curl -sL "https://raw.githubusercontent.com/ono7/dotfiles/refs/heads/main/hooks.json" -o "$USER_DOTFILES/hooks.json" 2>/dev/null || true

    echo "NOTE(jlima): Neovim user-space installation completed successfully."
    "${USER_BIN}/nvim" --version
else
    echo "NOTE(jlima): Invalid choice '$INSTALL_MODE'. Aborting."
    exit 1
fi
