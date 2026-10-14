-- %:r means root, same as %< which strips the leading file extension

vim.bo.makeprg = "g++ -std=c++20 -Wall -Wextra -Wpedantic -O2 -g % -o %:r"

-- NOTE(jlima): Standard Clang/GCC diagnostic output with multiline template backtrace pass-through.
vim.bo.errorformat = "%f:%l:%c: %trror: %m,%f:%l:%c: %tarning: %m,%f:%l:%c: %tote: %m,%f:%l:%c: %m,%f:%l: %m"
