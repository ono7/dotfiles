# ~/.zshenv (Loaded for ALL zsh instances - keep lean & sub-millisecond)

# Monitor / Display Scaling (Linux/Wayland)
# export QT_SCALE_FACTOR=2
# export QT_WAYLAND_FORCE_DPI=physical

# Global tool directories
export GOROOT="${HOME}/.local/go"
export GOPATH="${HOME}/go"
export PATH="${GOROOT}/bin:${GOPATH}/bin:${PATH}"
export ZK_NOTEBOOK_DIR="$HOME/notes"
export PATH="$HOME/.npm-global/bin:$PATH"
[[ -f $HOME/.work.sh ]] && source $HOME/.work.sh

# Fast Ubuntu check without cat pipe
[[ -f /etc/os-release ]] && grep -q "buntu" /etc/os-release 2>/dev/null && export skip_global_compinit=1
