.PHONY: linux
linux: linux-script clean

.PHONY: mac
mac: mac-script clean

.PHONY: clean
clean:
	rm -rf ~/.local/share/nvim
	rm -rf ~/.vim
	rm -rf ~/.config
	rm -f ~/.bashr
	rm -f ~/.zshrc
	rm -f ~/.zshenv
	rm -f ~/.ssh/config
	rm -f ~/.ctagsrc
	rm -rf ~/.ctags.d
	rm -f ~/.gdbinit
	rm -f ~/.gitignore
	rm -f ~/.inputrc
	rm -f ~/.tmux.conf
	./_scripts/stow.sh

.PHONY: linux-script
linux-script:
	./_scripts/setup_linux_deps.sh

.PHONY: mac-script
mac-script:
	./_scripts/setup_macos_deps.sh
