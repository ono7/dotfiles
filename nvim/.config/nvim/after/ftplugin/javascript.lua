vim.opt_local.autoindent = true
vim.opt_local.tabstop = 2
vim.opt_local.shiftwidth = 2
vim.opt_local.expandtab = true
vim.opt_local.formatoptions:remove({ "r", "o" })
vim.opt_local.commentstring = "// %s"
vim.opt_local.suffixesadd:append(".js")

vim.opt_local.makeprg = "eslint --format unix"
vim.opt_local.errorformat = "%f:%l:%c: %m"
