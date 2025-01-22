--- 🐇 Follow the white Rabbit...
-- :write ++p (creates directories if they dont exists)
local opt = { noremap = true }

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

if vim.g.neovide then
  --- vsync = true for smooth cursor movement, which is why we are here
  -- vim.api.nvim_set_hl(0, "Normal", { bg = "#1b1f31", fg = "#b8c1e6" })
  vim.api.nvim_set_hl(0, "Normal", { bg = "#1a1f32", fg = "#b8c1e6" })
  -- Map Cmd+g to Ctrl+g in multiple modes
  vim.keymap.set("i", "<D-g>", "<C-g>") -- Insert mode
  vim.keymap.set("n", "<D-g>", "<C-g>") -- Normal mode
  vim.keymap.set("n", "<D-a>", "<C-a>") -- Normal mode
  vim.keymap.set("v", "<D-g>", "<C-g>") -- Visual mode
  vim.keymap.set("x", "<D-g>", "<C-g>") -- Visual block mode

  -- Regular increment/decrement
  vim.keymap.set("n", "<D-a>", "<c-a>", opt)
  vim.keymap.set("n", "<D-x>", "<c-x>", opt)

  -- Visual mode increment/decrement
  vim.keymap.set("x", "<D-a>", "g<C-a>", opt)
  vim.keymap.set("x", "<D-x>", "g<C-x>", opt)

  vim.keymap.set("n", "<D-V>", '"+p', { noremap = true }) -- Normal mode
  vim.keymap.set("i", "<D-V>", "<C-R>+", { noremap = true }) -- Insert mode
  vim.keymap.set("v", "<D-V>", '"+p', { noremap = true }) -- Visual mode
  vim.keymap.set("t", "<D-V>", '<C-\\><C-N>"+pi', { noremap = true })
end

vim.opt.mouse = "a"

-- block cursor
vim.opt.guicursor = ""

-- require("old_plugins.jira-base")
require("jira.jira")
require("jira.jira-move")
require("jira.jira-fetch-issues")
require("jira.jira-fetch-issues-empty")
require("jira.jira-clone").setup()
