-- %:r means root, same as %< which strips the leading file extension

-- this does the same thing:
-- :Dispatch g++ % -o %< && ./%<

-- for standard programs
vim.b.dispatch = "g++ % -o %:r -g -O0 && ./%:r"

-- Keeps the shell open so you can see output/errors and prevents early buffer destruction
-- vim.b.start = "cd %:p:h:S && g++ %:t:S -o %:t:r:S && ./%:t:r:S; exec $SHELL"
