vim.bo.makeprg = "gcc -Og -g3 % -o %:r"

-- NOTE(jlima): Standard GCC diagnostic output: file:line:col: (fatal error|error|warning|note): message.
vim.bo.errorformat = "%f:%l:%c: %trror: %m,%f:%l:%c: %tarning: %m,%f:%l:%c: %tote: %m,%f:%l:%c: %m,%f:%l: %m"
