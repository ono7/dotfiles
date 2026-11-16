vim.opt_local.autoindent = true
vim.opt_local.tabstop = 2
vim.opt_local.softtabstop = 2
vim.opt_local.shiftwidth = 2
vim.opt_local.expandtab = true
vim.opt_local.suffixesadd:append(".yml")
vim.opt_local.suffixesadd:append(".yaml")
vim.opt_local.makeprg = "yamllint --f parsable %"
vim.opt_local.errorformat = "%f:%l:%c: %m"
vim.opt_local.formatoptions:remove({ "c", "r", "o" })
