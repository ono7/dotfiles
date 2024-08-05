SHELL := /bin/bash

.PHONY: install linux mac clean linux-deps mac-deps stow

BANNER = "--------------------- Running target: $@ ------------------------"

# Default target for easy installation
install:
	@echo $(BANNER)
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

linux: linux-deps clean stow

mac: mac-deps clean stow

clean:
	@echo $(BANNER)
	rm -rf ~/.vim
	rm -rf ~/.config
	rm -rf ~/.local/share/nvim
	rm -f ~/.alacritty-windows.toml
	rm -f ~/.bashrc
	rm -f ~/.sqliterc
	rm -f ~/.zshrc
	rm -f ~/.zshenv
	rm -f ~/.ssh/config
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

stow:
	@echo $(BANNER)
	@bash ./_scripts/stow.sh
	ln -sf $$(which sqlite3) ~/local/bin/sqlite

# installs OS dependencies

linux-deps:
	@echo $(BANNER)
	@bash ./_scripts/setup_linux_deps.sh

mac-deps:
	@echo $(BANNER)
	@bash ./_scripts/setup_macos_deps.sh
