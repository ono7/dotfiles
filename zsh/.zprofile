# ~/.zprofile
# Static environment for login shells & GUI app discovery (Neovide)

# Static Homebrew environment (instant, replaces slow $(brew shellenv))
export HOMEBREW_PREFIX="/opt/homebrew"
export HOMEBREW_CELLAR="/opt/homebrew/Cellar"
export HOMEBREW_REPOSITORY="/opt/homebrew"
export MANPATH="/opt/homebrew/share/man${MANPATH+:$MANPATH}:"
export INFOPATH="/opt/homebrew/share/info:${INFOPATH+:$INFOPATH}"

export GOPATH="$HOME/go"
export NVM_DIR="$HOME/.nvm"

# Static, deduplicated PATH
export PATH="$HOME/.npm-global/bin:$HOME/.virtualenvs/prod3/bin:$HOME/.nvm/versions/node/v23.5.0/bin:$HOME/.fzf/bin:$HOME/.local/bin:$HOME/.deno/bin:$HOME/local/bin:/opt/homebrew/sbin:/usr/local/sbin:/opt/homebrew/opt/grep/libexec/gnubin:/opt/homebrew/opt/gnu-sed/libexec/gnubin:$HOME/go/bin:$HOME/.rd/bin:$HOME/.luarocks/bin:/opt/homebrew/bin:$HOME/.npm-packages/bin:$HOME/local/node/bin:$HOME/local/yarn/bin:$HOME/bin:/usr/local/bin:/usr/local/share/dotnet:/usr/lib/cargo/bin:$HOME/.cargo/bin:$HOME/.cache/lm-studio/bin:$PATH"

typeset -U path PATH
