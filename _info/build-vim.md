## linux

## MacOS

```bash
deactivate

git clone https://github.com/vim/vim.git
cd vim

# Detect architecture and set optimization flags
ARCH=$(uname -m)
if [[ "$ARCH" == "arm64" ]]; then
    # Apple Silicon optimizations (M1/M2/M3/M4)
    export CFLAGS="-O3 -march=native -mtune=native -flto"
    export CXXFLAGS="-O3 -march=native -mtune=native -flto"
    export LDFLAGS="-flto"
    echo "Building for Apple Silicon with optimizations"
elif [[ "$ARCH" == "x86_64" ]]; then
    # x86_64 optimizations
    export CFLAGS="-O3 -march=native -mtune=native -flto -msse4.2 -mavx2"
    export CXXFLAGS="-O3 -march=native -mtune=native -flto -msse4.2 -mavx2"
    export LDFLAGS="-flto"
    echo "Building for x86_64 with optimizations"
else
    # Fallback for other architectures
    export CFLAGS="-O3"
    export CXXFLAGS="-O3"
    export LDFLAGS=""
    echo "Building for $ARCH with basic optimizations"
fi

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

## install fugitive
mkdir -p ~/.vim/pack/plugins/start

git clone https://github.com/tpope/vim-fugitive.git ~/.vim/pack/plugins/start/vim-fugitive
```
