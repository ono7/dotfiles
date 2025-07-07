#!/usr/bin/env bash

[ -z "$1" ] && echo "provide a build tag" && exit 1

if type go 2>/dev/null; then
  mkdir -p build
  mkdir -p images logs
  go mod init server
  go mod tidy
  env GOOS=linux GOARCH=amd64 go build -o build/server main.go
  podman build --tls-verify=false --platform linux/amd64 . --tag "$1"
  # podman push "$1" --tls-verify=false
  echo "Done!" && exit 0
fi

echo "go not installed...." && exit 1
