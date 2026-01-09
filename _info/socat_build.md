## build for MacOS

```bash
curl -LO http://www.dest-unreach.org/socat/download/socat-1.8.1.0.tar.gz
tar xzf socat-1.8.1.0.tar.gz
cd socat-1.8.1.0

./configure \
 CPPFLAGS="-I$(brew --prefix readline)/include" \
  LDFLAGS="-L$(brew --prefix readline)/lib"
make

cp ./socat ~/.local/bin/socat
```
