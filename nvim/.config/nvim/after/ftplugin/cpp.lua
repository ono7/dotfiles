-- %:r means root, same as %< which strips the leading file extension

-- this does the same thing:
-- :Dispatch g++ % -o %< && ./%<

-- for standard programs
vim.b.dispatch = "g++ % -o %:r && ./%:r"

-- for interactive programs that require input
vim.b.start = "cd %:p:h:S && g++ %:t:S -o %:t:r:S && ./%:t:r:S"
