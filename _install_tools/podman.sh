#!/usr/bin/env bash
# NOTE(jlima): pin target version or resolve latest stable tag via GitHub API
PODMAN_VERSION=$(curl -s https://api.github.com/repos/containers/podman/releases/latest | grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/')

curl -fsSL "https://github.com/containers/podman/releases/download/v${PODMAN_VERSION}/podman-remote-release-darwin_${ARCH}.zip" -o /tmp/podman.zip

unzip -q /tmp/podman.zip -d /tmp/podman-dist

# NOTE(jlima): place statically resolved binary in user-isolated PATH
mv /tmp/podman-dist/podman-remote-release-darwin_${ARCH}/usr/bin/podman ~/.local/bin/podman
chmod +x ~/.local/bin/podman

rm -rf /tmp/podman.zip /tmp/podman-dist
