SHELL := /bin/bash

export PATH := $(HOME)/.npm-packages/bin:$(HOME)/.fzf/bin:$HOME/linuxbrew/.linuxbrew/bin:$(HOME)/.local/bin:$(HOME)/local/bin:/opt/homebrew/sbin:/usr/local/sbin:/snap/bin:/opt/homebrew/opt/grep/libexec/gnubin:/opt/homebrew/opt/gnu-sed/libexec/gnubin:$(GOPATH)/bin:$(HOME)/.rd/bin:$(HOME)/.luarocks/bin:/opt/homebrew/bin:$(HOME)/.npm-packages/bin:$(HOME)/local/node/bin:$(HOME)/local/yarn/bin:$(HOME)/bin:/usr/local/bin:/usr/local/share/dotnet:/usr/lib/cargo/bin:$(HOME)/.cargo/bin:$(PATH)

FONT_REPO := https://github.com/ono7/fonts2.git
FONT_DIR  := $(HOME)/fonts2

.PHONY: homebrew brew-deps install linux mac clean linux-deps mac-deps stow fzf nvm done go-deps neovim starship ssh shell vim manjaro uv mac-keybinds fonts neovide

BANNER = "-------------------[ make: $@ ]-------------------"

install:
	@echo "run: make build"
# Default target for easy installation
build:
	@$(MAKE) detect-os

OS := $(shell uname -s)

# Detect the operating system and invoke the appropriate target
detect-os:
	@echo $(BANNER)
	@unameOut=$$(uname -s); \
	case "$$unameOut" in \
		Linux*)     machine=linux;; \
		Darwin*)    machine=mac;; \
		*)          machine="UNKNOWN:$$unameOut" ;; \
	esac; \
	echo "Detected: $$machine"; \
	if [ "$$machine" = "UNKNOWN:$$unameOut" ]; then \
		echo "Unsupported operating system. Exiting."; \
		exit 1; \
	fi; \
	$(MAKE) $$machine

# the order of execution on this targets is important
linux: linux-deps clean stow nvm go-deps uv vim fzf starship fonts neovide done
mac: mac-keybinds mac-deps homebrew brew-deps clean stow nvm go-deps uv fzf starship vim neovim neovide fonts done

clean:
	@echo $(BANNER)
	rm -rf ~/.vim
	rm -rf ~/.config
	rm -rf ~/.local/share/nvim
	rm -f ~/.alacritty-windows.toml
	rm -f ~/.bashrc
	rm -f ~/.emacs.d
	rm -f ~/.sqliterc
	rm -f ~/.aerospace
	rm -f ~/.zshrc
	rm -rf ~/.dlv
	rm -f ~/.zshenv
	rm -f ~/.ctagsrc
	rm -f ~/.npmrc
	rm -rf ~/.ctags.d
	rm -f ~/.gdbinit
	rm -f ~/.inputrc
	rm -f ~/local/bin/shortpath
	rm -f ~/.tmux.conf
	rm -f ~/.gitignore
	rm -f ~/.gitconfig-personal
	rm -rf ~/.git_templates
	rm -f ~/.gitconfig
	rm -f ~/.pdbrc
	rm -f ~/.cn.cnf
	rm -f ~/.pylintrc
	rm -f ~/.dircolors
	mkdir -p ~/local/bin
	mkdir -p ~/.config/neovide
	mkdir -p ~/.npm-global/bin
	mkdir -p ~/.tmp

stow:
	@echo $(BANNER)
	@bash ./_scripts/stow.sh

# make ssh/config not tracked in ~/.dotfiles
# ssh:
# 	@echo $(BANNER)
# 	stow -D ssh
# 	@cp ~/.dotfiles/ssh/.ssh/config ~/.ssh/config

homebrew:
	@echo $(BANNER)
	/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

brew-deps:
	@echo $(BANNER)
	@bash ./_scripts/setup_brew_packages.sh

fzf:
	@echo $(BANNER)
	@rm -rf ~/.fzf
	@git clone -q --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
	@~/.fzf/install --all

uv:
	@echo $(BANNER)
	@curl -LsSf https://astral.sh/uv/install.sh | sh
	@uv tool install black
	@uv tool install ansible-core
	@uv tool install ansible-lint
	@uv tool install isort
	@uv tool install ruff
	@uv tool install invoke
	@uv tool install poetry
	@uv tool install dnsdiag
	@uv tool install pynvim

nvm:
	@echo $(BANNER)
	@rm -rf ~/.nvm
	@bash ./_scripts/nvm.sh

shell:
	@echo $(BANNER)
	$$(which zsh) || return
	sudo usermod -s $$(which zsh) $$USER

manjaro:
	@echo $(BANNER)
	@bash ./_scripts/manjaro.sh

starship:
	@echo $(BANNER)
	@rm -f ~/.local/bin/starship || echo "starship not found"
	@mkdir -p ~/.local/bin
	@curl -sS https://starship.rs/install.sh | sh -s -- -b ~/.local/bin -y

linux-deps:
	@echo $(BANNER)
	@bash ./_scripts/setup_linux_deps.sh

neovim:
	@echo $(BANNER)
	@mkdir -p ~/.local/bin
	@touch ~/.workspaces
	@rm -rf $(HOME)/.local/share/nvim
	@bash ./_scripts/build-neovim.sh

neovide:
	@echo $(BANNER)
	@rm -rf ~/.config/neovide/config.toml
	@mkdir -p ~/.config/neovide
ifeq ($(OS),Darwin)
	@echo "Linking neovide config for macOS"
	@ln -s ~/.dotfiles/templates/macos-config.toml ~/.config/neovide/config.toml
else
	@echo "Linking neovide config for Linux"
	@ln -s ~/.dotfiles/templates/linux-config.toml ~/.config/neovide/config.toml
endif
	@echo "Neovide configuration linked successfully."

vim:
	@echo $(BANNER)
	@if [ "$(id -u)" != "0" ]; then \
		mkdir -p ~/.local/bin; \
	fi
	@bash ./_scripts/build-vim.sh

vim-user:
	@echo $(BANNER)
	@mkdir -p ~/.local/bin
	@VIM_USER_INSTALL=1 bash ./_scripts/build-vim.sh

mac-deps:
	@echo $(BANNER)
	@bash ./_scripts/setup_macos_deps.sh

mac-keybinds:
	@echo $(BANNER)
	mkdir -p ~/Library/KeyBindings
	rm -rf ~/Library/KeyBindings/DefaultKeyBinding.dict
	cp ~/.dotfiles/macos/DefaultKeyBinding.dict ~/Library/KeyBindings/

# installs go dependencies
go-deps:
	@echo $(BANNER)
	@bash ./_scripts/go-deps.sh

fonts:
	@echo "Removing existing font directory (if any)..."
	@rm -rf $(FONT_DIR)
	@echo "Cloning font repository to $(FONT_DIR)..."
	@git clone $(FONT_REPO) $(FONT_DIR)

ifeq ($(OS),Darwin)
	@echo "Installing fonts for macOS..."
	@find $(FONT_DIR) -name "*.ttf" -exec cp {} ~/Library/Fonts/ \;
	@echo "Fonts installed successfully."
else ifeq ($(OS),Linux)
	@echo "Installing fonts for Linux..."
	@mkdir -p ~/.local/share/fonts/
	@find $(FONT_DIR) -name "*.ttf" -exec cp {} ~/.local/share/fonts/ \;
	@fc-cache -fv
	@echo "Fonts installed successfully."
else
	@echo "OS $(OS) not supported for automatic font installation."
endif

# bootstrap neovim dependencies
done:
	@echo $(BANNER)
	@bash ./_scripts/nvim.sh
