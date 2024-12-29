local set_keys = require("utils.keys")

vim.opt.completeopt = { "longest" }
vim.opt.complete = { ".", "w", "b", "u" }
-- vim.opt.complete = { ".", "w", "b", "t" }
-- vim.opt.updatetime = 1000

-- Map Ctrl-Y to trigger completion and auto-select
vim.api.nvim_set_keymap("i", set_keys.prefix("y"), [[<C-n><c-p>]], { noremap = true, silent = true })
