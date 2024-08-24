--- 🐇 Follow the white Rabbit...
-- TODO: fix telescope to make files in projects filtered when doing oldfile lookups

vim.cmd [[ syntax off ]]

local k = vim.keymap.set
local opt = { noremap = true }
local silent = { noremap = true, silent = true }

-- if nothing else, this are the bare minimum necessities
vim.opt.path:append({ "**" })
vim.opt.shell = "zsh"
vim.opt.clipboard:append("unnamedplus")
vim.opt.wrap = false

vim.opt.shada = "'30,<3000,s100,:500,/100,h"

--- syntax off to avoid tree-sitter issues
vim.opt.syntax = "off"
vim.g.mapleader = " "

k("n", "+", ":e ~/todo.md<cr>", opt)

--- visual select last paste
k("n", "gp", "`[v`]", silent)

--- keep cursor in same position when yanking in visual
k("x", "y", [[ygv<Esc>]], silent)

-- vim.opt.winbar = "%=%M %-.45f %-m {%{get(b:, 'branch_name', '')}}"
vim.opt.winbar = "%=%-.75F %-m {%{get(b:, 'branch_name', '')}}"

-- might need this in the future
vim.g.skip_ts_context_commentstring_module = true

vim.g.markdown_fold_style = "nested"

-- reuse same window
vim.g.netrw_banner = 0
vim.g.netrw_browse_split = 0
vim.g.netrw_liststyle = 3

require("config.disabled")
require("config.legacy")
require("config.abbreviations")
require("config.diff-settings")
require("config.vars")
require("config.settings")
require("config.helper-functions")
require("config.lazy-config")
require("config.keymaps")
require("config.cmds")
require("themes.notheme") -- basic HL groups for no colorscheme
-- require("themes.gruvbox")


vim.keymap.set("n", "]d", "<cmd>lua vim.diagnostic.goto_prev({ float = true })<CR>")
vim.keymap.set("n", "[d", "<cmd>lua vim.diagnostic.goto_next({ float = true })<CR>")

-- uncomment for beam cursor
vim.opt.guicursor = ""
vim.opt.mouse = "n"

--- vim.cmd("set guicursor+=a:-blinkwait75-blinkoff75-blinkon75")
vim.cmd [[ syntax off ]]
