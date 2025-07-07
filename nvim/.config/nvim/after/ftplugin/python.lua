vim.opt_local.expandtab = true
vim.opt_local.lisp = false
vim.opt_local.smartindent = true
vim.opt_local.indentkeys = "!^F,o,O,<:>,0),0],0},=elif,=except"
vim.opt_local.suffixesadd:append(".py")
vim.opt_local.makeprg = "ruff check --output-format=concise %"
vim.opt_local.errorformat = "%f:%l:%c: %m"
