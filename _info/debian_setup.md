# setup debian

## docker

```bash

# 1. Update baseline packages and install prerequisites
sudo apt update && sudo apt install -y curl ca-certificates gnupg

# 2. Add Docker's official GPG key and declarative repository
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# 3. Install core runtime engine
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# 4. Add your user to the docker group
sudo usermod -aG docker $USER


# test
docker run --rm hello-world
```

```bash

# Disable the local DNS stub listener
sudo sed -r -i.orig 's/#?DNSStubListener=yes/DNSStubListener=no/g' /etc/systemd/resolved.conf

# Point host resolution directly to public DNS temporarily or symlink static resolv.conf
sudo systemctl restart systemd-resolved

# verify 

sudo ss -tulpn | grep :53
```
