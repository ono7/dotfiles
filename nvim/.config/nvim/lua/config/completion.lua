vim.opt.completeopt = { "longest" }
vim.opt.complete:append({ "w", "b", "t" })
vim.opt.updatetime = 100

-- Map Ctrl-Y to trigger completion and auto-select
vim.api.nvim_set_keymap("i", "<C-y>", [[<C-n><c-p>]], { noremap = true, silent = true })
