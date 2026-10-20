# NOTE(jlima): Purge site artifacts, plugin manager clones, state, and bytecode cache on macOS to resolve runtimepath corruption.

```bash
rm -rf ~/.local/share/nvim/site/parser
rm -rf ~/.local/share/nvim/site/queries
rm -rf ~/.local/share/nvim/site/pack/*/start/nvim-treesitter
rm -rf ~/.local/share/nvim/lazy/nvim-treesitter
rm -rf ~/.local/state/nvim/
rm -rf ~/.cache/nvim/
```
