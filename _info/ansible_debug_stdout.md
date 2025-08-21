## find the PID of python code

`ps aux | grep python`

## make sure playbook has this

```yml
environment:
  PYTHONUNBUFFERED: "1"
```

## attach and trace

`sudo strace -p 234 -e write -s 1024 2>&1`

`sudo strace -p 107 -e write -s 1024 2>&1 | grep "write(1"`

## Dockerfile

```
FROM python:3.11-slim

# Install system packages for debugging and network tools
RUN apt-get update && apt-get install -y \
    # Core debugging tools
    lsof \
    strace \
    procps \
    htop \
    netstat-nat \
    # Network debugging
    tcpdump \
    netcat-openbsd \
    telnet \
    curl \
    wget \
    dnsutils \
    # Development tools
    vim \
    git \
    openssh-client \
    direnv \
    tmux \
    # System utilities
    sudo \
    && rm -rf /var/lib/apt/lists/*

# Install Python packages
RUN pip install --no-cache-dir \
    ansible \
    ansible-core \
    requests \
    jinja2 \
    netaddr \
    # Useful debugging libraries
    pdbpp \
    ipython

# Create ansible user with sudo privileges
RUN useradd -m -s /bin/bash ansible && \
    echo 'ansible ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Set working directory
WORKDIR /ansible

# Copy all config files (setup.sh ensures they exist)
COPY --chown=ansible:ansible .vimrc /home/ansible/.vimrc
COPY --chown=ansible:ansible .tmux.conf /home/ansible/.tmux.conf

# Switch to ansible user
USER ansible

# Set up ansible configuration
RUN mkdir -p ~/.ansible && \
    echo '[defaults]' > ~/.ansible.cfg && \
    echo 'host_key_checking = False' >> ~/.ansible.cfg && \
    echo 'stdout_callback = debug' >> ~/.ansible.cfg && \
    echo 'log_path = ./ansible.log' >> ~/.ansible.cfg

# Configure bash with vi mode and direnv
RUN echo 'set -o vi' >> ~/.bashrc && \
    echo 'eval "$(direnv hook bash)"' >> ~/.bashrc && \
    echo 'export EDITOR=vim' >> ~/.bashrc

# Default command
CMD ["/bin/bash"]
```

## podman-compose.yml

```

services:
  ansible:
    build: .
    container_name: ansible-dev
    volumes:
      - .:/ansible:Z
      - ansible_cache:/home/ansible/.ansible:Z
    working_dir: /ansible
    tty: true
    stdin_open: true
    # Podman security context instead of privileged
    security_opt:
      - label=disable
    # Add capabilities for network debugging
    cap_add:
      - NET_ADMIN
      - NET_RAW
      - SYS_PTRACE
    # Keep container running
    command: tail -f /dev/null
    environment:
      - ANSIBLE_HOST_KEY_CHECKING=False
      - ANSIBLE_STDOUT_CALLBACK=debug
    networks:
      - ansible-net

volumes:
  ansible_cache:

networks:
  ansible-net:
    driver: bridge
```

## setup.sh

```

#!/bin/bash
# Copy dotfiles from home directory to build context

echo "Setting up configuration files..."

# Always create .vimrc (copy from home or create default)
if [ -f ~/.vimrc ]; then
  cp ~/.vimrc .
  echo "✓ Copied ~/.vimrc from home directory"
else
  echo "⚠ No ~/.vimrc found, creating default"
  cat >.vimrc <<'EOF'
set number
set hlsearch
set incsearch
set expandtab
set tabstop=4
set shiftwidth=4
syntax on
EOF
  echo "✓ Created default .vimrc"
fi

# Always create .tmux.conf (copy from home or create default)
if [ -f ~/.tmux.conf ]; then
  cp ~/.tmux.conf .
  echo "✓ Copied ~/.tmux.conf from home directory"
else
  echo "⚠ No ~/.tmux.conf found, creating default"
  cat >.tmux.conf <<'EOF'
# Set prefix to Ctrl-a
set -g prefix C-a
unbind C-b
bind-key C-a send-prefix

# Split panes using | and -
bind | split-window -h
bind - split-window -v
unbind '"'
unbind %

# Reload config file
bind r source-file ~/.tmux.conf \; display "Config reloaded!"

# Enable mouse control
set -g mouse on

# Don't rename windows automatically
set-option -g allow-rename off

# Start windows and panes at 1, not 0
set -g base-index 1
setw -g pane-base-index 1
EOF
  echo "✓ Created default .tmux.conf"
fi

echo "Configuration files ready for Docker build!"
```

## Makefile

```

.PHONY: build up down shell logs clean envrc status setup

# Use podman-compose instead of docker-compose
COMPOSE := podman-compose
COMPOSE_FILE := podman-compose.yml

setup:
  @echo "Copying vimrc..."
  @cp ~/.vimrc . 2>/dev/null || echo "set number\nset hlsearch\nset incsearch\nsyntax on" > .vimrc

build: setup
  $(COMPOSE) -f $(COMPOSE_FILE) build

up: build
  $(COMPOSE) -f $(COMPOSE_FILE) up -d

down:
  $(COMPOSE) -f $(COMPOSE_FILE) down

shell:
  $(COMPOSE) -f $(COMPOSE_FILE) exec ansible bash

# Direct podman exec alternative
exec:
  podman exec -it ansible-dev bash

logs:
  $(COMPOSE) -f $(COMPOSE_FILE) logs -f ansible

clean:
  $(COMPOSE) -f $(COMPOSE_FILE) down -v
  podman image rm ansible_ansible 2>/dev/null || true
  rm -f .vimrc

debug: up shell

envrc:
  @echo "Creating sample .envrc file..."
  @echo 'export ANSIBLE_INVENTORY=./inventory' > .envrc
  @echo 'export ANSIBLE_HOST_KEY_CHECKING=False' >> .envrc
  @echo "Edit .envrc with: vim .envrc"

status:
  podman machine info
  podman ps -a

# Podman-specific commands
machine-start:
  podman machine start

machine-stop:
  podman machine stop

machine-reset:
  podman machine rm default -f
  podman machine init --cpus 4 --memory 8192 --disk-size 60
  podman machine start

```
