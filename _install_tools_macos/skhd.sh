# Ensure destination directories exist
mkdir -p ~/.local/bin ~/.local/src

# Clone and build
git clone https://github.com/koekeishiya/skhd.git ~/.local/src/skhd
cd ~/.local/src/skhd
make

# Install binary locally
cp bin/skhd ~/.local/bin/skhd
chmod +x ~/.local/bin/skhd
