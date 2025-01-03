--- 🐇 Follow the white Rabbit...
-- :write ++p (creates directories if they dont exists)

vim.hl = vim.highlight
vim.cmd([[syntax off]])

if vim.opt.termguicolors then
  -- if truecolor is supported, lets make it better for neovim
  vim.cmd([[let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"]])
  vim.cmd([[let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"]])
end

vim.g.syntax_on = false
vim.opt.syntax = "off"

require("config.neovide")
require("config.options")
require("config.keymaps")
require("config.disabled")
require("config.legacy")
require("config.abbreviations")
require("config.diff-settings")
require("config.vars")
require("config.helper-functions")
require("config.lazy")
require("utils.zoxide").setup()
require("utils.runner").setup() -- runs anything :M <cmd> :)
require("utils.runner-hook").setup() -- :H <cmd>  adds monitoring hook that triggers on file save
require("utils.create-table").setup()
require("config.commands")
require("config.autocmds")
require("config.completion")
require("utils.help-lookup").setup()

vim.opt.mouse = "a"

if vim.g.neovide then
  --- vsync = true for smooth cursor movement, which is why we are here
  vim.api.nvim_set_hl(0, "Normal", { bg = "#1b1f31", fg = "#b8c1e6" })
end

-- block cursor
vim.opt.guicursor = ""

-- require("old_plugins.jira-base")
require("jira.jira")
require("jira.jira-move")
require("jira.jira-fetch-issues")
require("jira.jira-fetch-issues-empty")
require("jira.jira-clone").setup()
