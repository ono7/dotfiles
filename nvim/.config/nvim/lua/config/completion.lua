-- Set completion options
-- vim.opt.completeopt = { "menu", "longest" }
vim.opt.completeopt = { "longest" }
-- vim.opt.complete:append({ "w", "b", "u", "t", "i" })
vim.opt.complete:append({ "w", "b", "t" })

-- reduce completeopt menu time
vim.opt.updatetime = 100

-- Map Ctrl-Y to trigger completion and auto-select
vim.api.nvim_set_keymap("i", "<C-y>", [[<C-n><c-p>]], { noremap = true, silent = true })
