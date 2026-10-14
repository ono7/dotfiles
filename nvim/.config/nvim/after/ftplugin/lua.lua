vim.opt_local.autoindent = true
vim.opt_local.tabstop = 2
vim.opt_local.shiftwidth = 2
vim.opt_local.expandtab = true
vim.opt_local.formatoptions:remove({ "r", "o" })
vim.opt_local.suffixesadd:append(".lua")
-- NOTE(jlima): Set buffer-local compiler command and errorformat to avoid leaking to other filetypes.
vim.bo.makeprg = "lua %"
vim.bo.errorformat = "lua: %f:%l: %m,%-G%.%#"
