--- 🐇 Follow the white Rabbit...
-- :write ++p (creates directories if they dont exists)

vim.cmd [[ syntax off ]]


local my_background = "#1f2937"
local my_background_lighter = "#24364b"
local my_background_darker = "#192636"

vim.api.nvim_set_hl(0, "Normal", {})
vim.api.nvim_set_hl(0, "Error", { fg = "#F38BA8", bold = false, italic = true })
vim.api.nvim_set_hl(0, "ErrorMsg", { link = "Error" })
vim.api.nvim_set_hl(0, "DiagnosticError", { link = "Error" })
vim.api.nvim_set_hl(0, "@text.todo", { link = "ErrorMsg" })
vim.api.nvim_set_hl(0, "@text.danger", { link = "ErrorMsg" })
vim.api.nvim_set_hl(0, "@text.note", { link = "Normal" })
vim.api.nvim_set_hl(0, "Todo", { link = "ErrorMsg" })
vim.api.nvim_set_hl(0, "TelescopeMatching", { link = "ErrorMsg" })
vim.api.nvim_set_hl(0, "ModeMsg", {})
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
vim.api.nvim_set_hl(0, "Winbar", { fg = "#a89984" })
vim.api.nvim_set_hl(0, "WinbarNc", { fg = "#a89984" })
vim.api.nvim_set_hl(0, "StatusLine", { bg = "#182a44" })
vim.api.nvim_set_hl(0, "TelescopeSelection", { bg = "#2b3b55" })
vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "#171c28", fg = "#8186a1" })
vim.api.nvim_set_hl(0, "Folded", { bg = "none", fg = "#8186a1", bold = true, italic = true })
vim.api.nvim_set_hl(0, "Visual", { bg = "#24364b", fg = "#d4d4d4" })
vim.api.nvim_set_hl(0, "Search", { bg = "#ceeac8", })
vim.api.nvim_set_hl(0, "MatchParen", { bg = "none", fg = "none", underline = true, bold = true })
vim.api.nvim_set_hl(0, "TreesitterContext", { bg = my_background_lighter })
vim.api.nvim_set_hl(0, "DiffAdd", { fg = "#ceeac8" })
vim.api.nvim_set_hl(0, "DiffDelete", { fg = "#212c3e" })
vim.api.nvim_set_hl(0, "DiffChange", { bg = "#2b3b55" })
vim.api.nvim_set_hl(0, "DiffText", { bg = "#9eb0ce", fg = "#000000" })
vim.api.nvim_set_hl(0, "Pmenu", { bg = "#161c29", fg = "#9eb0ce" })
vim.api.nvim_set_hl(0, "PmenuSel", { bg = "#4a6898", fg = "#000000" })
-- vim.api.nvim_set_hl(0, "cmpSelect", { bg = "#4a6898", fg = "#000000" })
vim.api.nvim_set_hl(0, "cmpSelect", { bg = "#ffa5c3", fg = "#000000" })
vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#2b3b55" })
vim.api.nvim_set_hl(0, "cmpBorder", { fg = "#2b3b55" })
vim.api.nvim_set_hl(0, "TelescopeBorder", { fg = "#2b3b55" })
vim.api.nvim_set_hl(0, "TelescopeTitle", { fg = "#9eb0ce" })




local opt = { noremap = true }
local silent = { noremap = true, silent = true }

-- improve matchparen performance
vim.g.matchparen_timeout = 20        -- default is 300
vim.g.matchparen_insert_timeout = 20 -- default is 60
vim.g.loaded_matchparen = 1

-- if nothing else, this are the bare minimum necessities
vim.opt.path:append({ "**" })
vim.opt.shell = "zsh"
vim.opt.clipboard:append("unnamedplus")
vim.opt.wrap = false

vim.opt.shada = "'40,<1000,s100,:300,/100,h"

--- syntax off to avoid tree-sitter issues
vim.opt.syntax = "off"
vim.g.mapleader = " "

vim.keymap.set("n", "+", ":e ~/todo.md<cr>", opt)

--- visual select last paste
vim.keymap.set("n", "gp", "`[v`]", silent)

--- keep cursor in same position when yanking in visual
vim.keymap.set("x", "y", [[ygv<Esc>]], silent)

-- might need this in the future
vim.g.skip_ts_context_commentstring_module = true

vim.g.markdown_fold_style = "nested"

-- reuse same window
vim.g.netrw_banner = 0
vim.g.netrw_browse_split = 0
vim.g.netrw_liststyle = 3

vim.opt.winbar = "%=%-.75F %-m"
-- vim.opt.winbar = "%=%-.75F %-m %{FugitiveStatusline()}"

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
require("plugins.jira")
require("plugins.jira-done")

-- require("themes.notheme") -- basic HL groups for no colorscheme
-- require("themes.gruvbox")

vim.keymap.set("n", "]d", "<cmd>lua vim.diagnostic.goto_prev({ float = true })<CR>")
vim.keymap.set("n", "[d", "<cmd>lua vim.diagnostic.goto_next({ float = true })<CR>")

-- comment for beam cursor
vim.opt.guicursor = ""
vim.opt.mouse = "n"

vim.cmd [[ syntax off ]]
