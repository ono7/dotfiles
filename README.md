## setup dotfiles

Any directories that start with `_` should be ignored by stow

```bash
git clone https://github.com/ono7/dotfiles.git ~/.dotfiles
cd $_
make install

# removes ~/.ssh/config link, used for sshs)
stow -D ssh

# update go-deps
make go-deps
```
