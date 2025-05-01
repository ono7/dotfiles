--- 🐇 Follow the white Rabbit...

--[[

* :write ++p (creates directories if they dont exists)

* neovim 0.11 defaults for lsp_attach
* grn in Normal mode maps to vim.lsp.buf.rename()
* grr in Normal mode maps to vim.lsp.buf.references()
* gri in Normal mode maps to vim.lsp.buf.implementation()
* gO in Normal mode maps to vim.lsp.buf.document_symbol()
* gra in Normal and Visual mode maps to vim.lsp.buf.code_action()
* CTRL-S in Insert and Select mode maps to vim.lsp.buf.signature_help()
* :s/foo/<Ctrl-R>0/g | replace with contents of unnamed reg 0

]]

vim.loader.enable(true)

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
require("utils.runner").setup() -- runs anything :M <cmd> :)
require("utils.runner-hook").setup() -- :H <cmd>  adds monitoring hook that triggers on file save
require("utils.create-table").setup()
require("config.commands")
require("config.autocmds")
require("config.lsp").setup()
require("utils.help-lookup").setup()

vim.opt.mouse = "a"

-- block cursor
vim.opt.guicursor = ""

-- require("old_plugins.jira-base")
require("jira.jira")
require("jira.jira-move")
require("jira.jira-fetch-issues")
require("jira.jira-fetch-issues-empty")
require("jira.jira-clone").setup()

-- vim.opt.completeopt = { "menu" }

vim.opt.completeopt = { "menu", "menuone" }

-- . = this buffer, w = from other windows, b = other loaded buffers
vim.opt.complete = { ".", "w", "b", "u" }

local function smart_completion()
  if vim.fn.pumvisible() == 1 then
    -- If completion menu is visible, select next item
    return "<C-n>"
  else
    -- If no menu is visible, trigger completion
    return "<C-x><C-n>"
  end
end

-- Map D-y or C-y to the smart completion function
if vim.fn.has("macunix") == 1 then
  vim.api.nvim_set_keymap(
    "i",
    "<D-y>",
    "v:lua.require('vim.lsp.util')._complete_done()",
    { expr = true, noremap = true, silent = true }
  )
  vim.keymap.set("i", "<D-y>", function()
    return smart_completion()
  end, { expr = true, noremap = true, silent = true })
else
  vim.keymap.set("i", "<C-y>", function()
    return smart_completion()
  end, { expr = true, noremap = true, silent = true })
end

-- Optional: Add mappings for navigating the completion menu
vim.api.nvim_set_keymap("i", "<C-j>", "pumvisible() ? '<C-n>' : '<C-j>'", { expr = true, noremap = true })
vim.api.nvim_set_keymap("i", "<C-k>", "pumvisible() ? '<C-p>' : '<C-k>'", { expr = true, noremap = true })
