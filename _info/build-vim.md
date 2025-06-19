## linux

## MacOS

```bash
# Deactivate your virtualenv first
deactivate

git clone https://github.com/vim/vim.git
cd vim

export CFLAGS="-O3 -march=native -mtune=native -flto"
export CXXFLAGS="-O3 -march=native -mtune=native -flto"
export LDFLAGS="-flto"

# Use Homebrew's Python directly
./configure \
    --with-features=huge \
    --enable-multibyte \
    --enable-python3interp=yes \
    --with-python3-command=/opt/homebrew/bin/python3 \
    --with-python3-config-dir=$(/opt/homebrew/bin/python3-config --configdir) \
    --enable-perlinterp=yes \
    --enable-luainterp=yes \
    --enable-rubyinterp=yes \
    --with-ruby-command=$(which ruby) \
    --enable-cscope \
    --enable-terminal \
    --with-compiledby="ono7" \
    --prefix=$HOME/.local/vim

make && make install
```
