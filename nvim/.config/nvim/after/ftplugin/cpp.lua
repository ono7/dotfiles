-- %:r means root, same as %< which strips the leading file extension

-- this does the same thing:
-- :Dispatch g++ % -o %< && ./%<

-- for standard programs
vim.b.dispatch = "g++ % -o %:r && ./%:r"

-- for interactive programs that require imput
vim.b.start = "g++ % -o %:r && ./%:r"
