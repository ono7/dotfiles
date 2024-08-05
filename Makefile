.PHONY: install linux mac clean linux-script mac-script stow

BANNER := "--------------------- Running target: $@ ------------------------"

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

linux: linux-script clean stow

mac: mac-script clean stow

clean:
	@echo $(BANNER)
	rm -rf ~/.local/share/nvim
	rm -rf ~/.vim
	rm -rf ~/.config
	rm -f ~/.bashrc
	rm -f ~/.sqliterc
	rm -f ~/.zshrc
	rm -f ~/.zshenv
	rm -f ~/.ssh/config
	rm -f ~/.ctagsrc
	rm -rf ~/.ctags.d
	rm -f ~/.gdbinit
	rm -f ~/.gitignore
	rm -f ~/.inputrc
	rm -f ~/.tmux.conf
	rm -rf ~/.git_templates
	rm -rf ~/.gitconfig

stow:
	@echo $(BANNER)
	@bash ./_scripts/stow.sh

# installs OS dependencies

linux-script:
	@echo $(BANNER)
	@bash ./_scripts/setup_linux_deps.sh

mac-script:
	@echo $(BANNER)
	@bash ./_scripts/setup_macos_deps.sh
