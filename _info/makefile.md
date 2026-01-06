# notes on Makefiles

```make
BINARY_NAME=clues

.PHONY: all clean windows macos

all: clean windows macos

windows:
  GOOS=windows GOARCH=amd64 go build -o $(BINARY_NAME).exe .

macos:
  GOOS=darwin GOARCH=arm64 go build -o $(BINARY_NAME) .

clean:
  rm -rf $(BUILD_DIR)
```

```make
# variables

whoami    := $(shell whoami)  # shell commands
host-type := $(shell arch)

CC = cc
CFLAGS = -g

mytarget: cfiles.c
  ${CC} ${CFLAGS} cfiles.c -o test

```
