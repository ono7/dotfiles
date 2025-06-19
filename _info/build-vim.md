## linux

```
deactivate

sudo apt update
sudo apt install -y \
    build-essential \
    git \
    make \
    autoconf \
    automake \
    cmake \
    pkg-config

sudo apt install -y \
    libncurses5-dev \
    libncursesw5-dev \
    libtinfo-dev \
    gettext

sudo apt install -y \
    libncurses5-dev \
    libncursesw5-dev \
    libtinfo-dev \
    gettext

sudo apt install -y \
    python3-dev \
    python3-distutils \
    libpython3-dev \
    ruby-dev \
    lua5.2-dev \
    liblua5.2-dev \
    libperl-dev \
    tcl-dev

git clone https://github.com/vim/vim.git
cd vim

if grep -q "avx2" /proc/cpuinfo; then
  VECTOR_FLAGS="-msse4.2 -mavx2"
elif grep -q "sse4_2" /proc/cpuinfo; then
  VECTOR_FLAGS="-msse4.2"
else
  VECTOR_FLAGS=""
fi

export CFLAGS="-O3 -march=native -mtune=native -flto $VECTOR_FLAGS"
export CXXFLAGS="-O3 -march=native -mtune=native -flto $VECTOR_FLAGS"
export LDFLAGS="-flto"
./configure \
    --with-features=huge \
    --enable-multibyte \
    --enable-python3interp=yes \
    --with-python3-config-dir=$(python3-config --configdir) \
    --enable-perlinterp=yes \
    --enable-luainterp=yes \
    --enable-rubyinterp=yes \
    --with-ruby-command=$(which ruby) \
    --enable-cscope \
    --enable-terminal \
    --with-compiledby="ono7" \
    --prefix=/usr/local \
    --enable-gui=no \
    --without-x \
    --disable-xsmp \
    --disable-xsmp-interact \
    --disable-netbeans \
    --enable-fail-if-missing

make && make install

## install fugitive
mkdir -p ~/.vim/pack/plugins/start

git clone https://github.com/tpope/vim-fugitive.git ~/.vim/pack/plugins/start/vim-fugitive

echo "Built with $CFLAGS"
```

## MacOS

```bash
deactivate

git clone https://github.com/vim/vim.git
cd vim

if grep -q "avx2" /proc/cpuinfo; then
  VECTOR_FLAGS="-msse4.2 -mavx2"
elif grep -q "sse4_2" /proc/cpuinfo; then
  VECTOR_FLAGS="-msse4.2"
else
  VECTOR_FLAGS=""
fi

export CFLAGS="-O3 -march=native -mtune=native -flto $VECTOR_FLAGS"
export CXXFLAGS="-O3 -march=native -mtune=native -flto $VECTOR_FLAGS"
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

## install fugitive
mkdir -p ~/.vim/pack/plugins/start

git clone https://github.com/tpope/vim-fugitive.git ~/.vim/pack/plugins/start/vim-fugitive

echo "Built with $CFLAGS"
```
