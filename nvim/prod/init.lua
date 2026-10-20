-- ==============================================================================
-- Entrypoint: Min-Config Neovim
-- ==============================================================================
vim.loader.enable()

vim.g.mapleader = " "
vim.g.loaded_tutor_mode_plugin = 1
vim.g.loaded_2html_plugin = 1
vim.g.loaded_matchparen = 1
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_python3_provider = 0

require("options")
require("keymaps")
require("autocmds")
require("tools")
require("plugins")

local neovide_path = vim.fn.expand("~/.dotfiles/nvim/.config/nvim/lua/config/neovide.lua")
if vim.g.neovide and vim.fn.filereadable(neovide_path) == 1 then
	dofile(neovide_path)
end
