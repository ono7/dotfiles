SHELL := /bin/bash

.PHONY: install linux mac clean linux-deps mac-deps stow fzf nvm done go-deps linux-neovim starship ssh shell

BANNER = "-------------------[ make: $@ ]-------------------"

# Default target for easy installation
install:
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
linux: linux-deps clean stow nvm go-deps linux-neovim fzf starship done
mac: mac-deps clean stow nvm go-deps fzf starship done

clean:
	@echo $(BANNER)
	rm -rf ~/.vim
	rm -rf ~/.config
	rm -rf ~/.local/share/nvim
	rm -f ~/.alacritty-windows.toml
	rm -f ~/.bashrc
	rm -f ~/.sqliterc
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

stow:
	@echo $(BANNER)
	@bash ./_scripts/stow.sh

# make ssh/config not tracked in ~/.dotfiles
ssh:
	@echo $(BANNER)
	stow -D ssh
	cp ~/.dotfiles/ssh/.ssh/config ~/.ssh/config

fzf:
	@echo $(BANNER)
	rm -rf ~/.fzf
	git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
	~/.fzf/install --all

nvm:
	@echo $(BANNER)
	rm -rf ~/.nvm
	@bash ./_scripts/nvm.sh

shell:
	@echo $(BANNER)
	$$(which fzf) || return
	sudo usermod -s $$(which fzf) $$USER

starship:
	@echo $(BANNER)
	rm -f ~/.local/bin/starship || echo "starship not found"
	mkdir -p ~/.local/bin
	curl -sS https://starship.rs/install.sh | sh -s -- -b ~/.local/bin -y

linux-deps:
	@echo $(BANNER)
	@bash ./_scripts/setup_linux_deps.sh

linux-neovim:
	@echo $(BANNER)
	mkdir -p ~/local/bin
	@bash ./_scripts/linux-neovim-setup.sh

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
	nvim
