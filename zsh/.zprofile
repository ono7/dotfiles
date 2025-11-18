# vim: ft=bash

# this is needed for neovide

if [[ -f /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

export GOPATH=$HOME/go

export PATH="/Users/$USER/.virtualenvs/prod3/bin:/Users/$USER/.nvm/versions/node/v23.5.0/bin:/Users/$USER/.fzf/bin:/Users/$USER/.local/bin:/Users/$USER/.deno/bin:/Users/$USER/local/bin:/opt/homebrew/sbin:/usr/local/sbin:/snap/bin:/opt/homebrew/opt/grep/libexec/gnubin:/opt/homebrew/opt/gnu-sed/libexec/gnubin:/Users/$USER/go/bin:/Users/$USER/.rd/bin:/Users/$USER/.luarocks/bin:/opt/homebrew/bin:/Users/$USER/.npm-packages/bin:/Users/$USER/local/node/bin:/Users/$USER/local/yarn/bin:/Users/$USER/bin:/usr/local/bin:/usr/local/share/dotnet:/usr/lib/cargo/bin:/Users/$USER/.cargo/bin:/System/Cryptexes/App/usr/bin:/usr/bin:/bin:/usr/sbin:/sbin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/local/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/appleinternal/bin:/Library/Apple/usr/bin:/Users/$USER/.cache/lm-studio/bin"

############# NVM configuration ##############

export NVM_DIR="$HOME/.nvm"
[ -f "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -f "$NVM_DIR/zsh_completion" ] && \. "$NVM_DIR/zsh_completion"
