-- Set up completion options
vim.opt.complete:append(".")
vim.opt.complete:append("w")
vim.opt.complete:append("b")
vim.opt.complete:append("u")
vim.opt.complete:append("t")
vim.opt.complete:append("i")
-- Configure completion behavior

vim.opt.completeopt = { "menu", "menuone", "longest" }
-- vim.opt.completeopt = { "menuone", "longest" }

vim.opt.shortmess:append("c")

-- Set minimum chars for completion popup
vim.opt.pumheight = 10

-- Make completion more responsive
-- vim.opt.updatetime = 300

-- Enable case-smart completion
vim.opt.infercase = true

-- Map Ctrl-Y to trigger completion
-- vim.keymap.set("i", "<c-y>", "", {})
-- vim.keymap.set("i", "<c-y>", "<C-n>", { noremap = true, silent = true })

vim.keymap.set("i", "<C-y>", "<C-x><C-n>", { noremap = true, silent = true })
