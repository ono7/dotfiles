-- Set completion options
vim.opt.completeopt = { "menu", "longest" }
vim.opt.complete:append({ "w", "b", "u", "t", "i" })

-- Reduce completion menu delay
vim.opt.updatetime = 120
-- Map Ctrl-Y to trigger completion and auto-select
vim.api.nvim_set_keymap("i", "<C-y>", [[<C-n><C-n>]], { noremap = true, silent = true })
