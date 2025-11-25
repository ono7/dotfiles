SHELL := /bin/bash

export PATH := $(HOME)/.fzf/bin:$HOME/linuxbrew/.linuxbrew/bin:$(HOME)/.local/bin:$(HOME)/local/bin:/opt/homebrew/sbin:/usr/local/sbin:/snap/bin:/opt/homebrew/opt/grep/libexec/gnubin:/opt/homebrew/opt/gnu-sed/libexec/gnubin:$(GOPATH)/bin:$(HOME)/.rd/bin:$(HOME)/.luarocks/bin:/opt/homebrew/bin:$(HOME)/.npm-packages/bin:$(HOME)/local/node/bin:$(HOME)/local/yarn/bin:$(HOME)/bin:/usr/local/bin:/usr/local/share/dotnet:/usr/lib/cargo/bin:$(HOME)/.cargo/bin:$(PATH)


.PHONY: homebrew brew-deps install linux mac clean linux-deps mac-deps stow fzf nvm done go-deps neovim starship ssh shell vim manjaro uv

BANNER = "-------------------[ make: $@ ]-------------------"

install:
	@echo "run: make build"
# Default target for easy installation
build:
	@$(MAKE) detect-os

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
linux: linux-deps homebrew brew-deps clean stow nvm go-deps uv neovim vim fzf starship done
mac: mac-deps homebrew brew-deps clean stow nvm go-deps uv fzf starship vim neovim done

clean:
	@echo $(BANNER)
	rm -rf ~/.vim
	rm -rf ~/.config
	rm -rf ~/.local/share/nvim
	rm -f ~/.alacritty-windows.toml
	rm -f ~/.bashrc
	rm -f ~/.sqliterc
	rm -f ~/.aerospace
	rm -f ~/.zshrc
	rm -rf ~/.dlv
	rm -f ~/.zshenv
	rm -f ~/.ctagsrc
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
	@uv tool install poetry
	@poetry config virtualenvs.in-project true

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
	@bash ./_scripts/build-neovim.sh

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

# installs go dependencies
go-deps:
	@echo $(BANNER)
	@bash ./_scripts/go-deps.sh

# bootstrap neovim dependencies
done:
	@echo $(BANNER)
	@bash ./_scripts/nvim.sh
