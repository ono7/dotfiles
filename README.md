## setup dotfiles

## boot strap basic install for debian

> wget -qO- https://raw.githubusercontent.com/ono7/dotfiles/refs/heads/main/setup.sh | sudo bash

Any directories that start with `_` should be ignored by stow

```bash
git clone https://github.com/ono7/dotfiles.git ~/.dotfiles
cd $_
make install

# removes ssh stow link ~/.ssh/config
stow -D ssh

stow nvim

# update go-deps
make go-deps
make mac-keybinds
```
