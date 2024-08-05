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
	./setup.sh
