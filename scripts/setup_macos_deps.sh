#/bin/bash

echo "$0"

echo '========== install homebrew =========='

[ ! -d /opt/homebrew/bin ] && /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

echo '========== install brew packages =========='

brew install ansifilter wget tree go neovim rar clang-format zoxide wezterm grep netcat
brew install fd cmake ack rg coreutils ssh-copy-id jq p7zip curl tmux universal-ctags mtr lua ninja rust npm starship stow
brew install bpytop pinentry-mac
brew install golang delve amethyst
npm install lua-fmt prettier jsonlint typescript eslint jsonlint doctoc -g
