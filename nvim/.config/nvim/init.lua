--- 🐇 Follow the white Rabbit...

--[[

* view all compilers included with vim
:e $VIMRUNTIME/compiler
:compiler go
:make % or :make

* plain vim setup for remote systems
alias vim='vim -c "let mapleader=\" \" | set nobackup nowritebackup noswapfile | set clipboard=unnamedplus | set number relativenumber | set ignorecase smartcase nohlsearch | set autoindent expandtab shiftwidth=2 | set laststatus=0 | set shortmess+=I | nnoremap <leader>w :w<cr> | nnoremap <leader>d :bd!<cr> | nnoremap <c-h> <C-W><C-H> | nnoremap <c-j> <C-W><C-J> | nnoremap <c-k> <C-W><C-K> | nnoremap <c-l> <C-W><C-L> | nnoremap <silent> <Esc> :nohlsearch<CR>"'

* == auto indent
* insert mode: c-t and c-d to indent/unindent a line that is not in the corret indent level
* set dir to current open file, :cd %:h
* add all files to buff for faster navigation :argadd **/*.py
  * apply commands to open args list
    :sall
    :tab sall
    :argdo %s/test/Test/gc
* :write ++p (creates directories if they dont exists)
* neovim 0.11 defaults for lsp_attach
* grn in Normal mode maps to vim.lsp.buf.rename()
* grr in Normal mode maps to vim.lsp.buf.references()
* gri in Normal mode maps to vim.lsp.buf.implementation()
* gO in Normal mode maps to vim.lsp.buf.document_symbol()
* gra in Normal and Visual mode maps to vim.lsp.buf.code_action()
* CTRL-S in Insert and Select mode maps to vim.lsp.buf.signature_help()
* :s/foo/<Ctrl-R>0/g | replace with contents of unnamed reg 0
* use :b <part of buffer name><tab> to find open tags

]]

vim.loader.enable(true)
vim.cmd([[syntax off]])

if vim.opt.termguicolors then
  -- if truecolor is supported, lets make it better for neovim
  vim.cmd([[let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"]])
  vim.cmd([[let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"]])
end

vim.g.syntax_on = false
vim.opt.syntax = "off"

require("config.options")
require("config.keymaps")
require("config.disabled")
require("config.legacy")
require("config.abbreviations")
require("config.diff-settings")
require("config.vars")
require("config.helper-functions")
require("config.lazy")
require("utils.change-path").setup() -- :Cd (toggle root dir and cwd)
require("utils.create-table").setup()
require("config.commands")
require("config.autocmds")
require("config.lsp").setup()
require("config.neovide")

require("utils.help-lookup").setup()

--- these two worktogether
require("utils.runner").setup() -- runs anything :M <cmd> :)
require("utils.runner-hook").setup() -- :H <cmd>  adds monitoring hook that triggers on file save
require("utils.ruff")

vim.opt.mouse = "a"

-- block cursor
vim.opt.guicursor = ""

-- require("old_plugins.jira-base")
-- require("jira.jira")
-- require("jira.jira-move")
-- require("jira.jira-fetch-issues")
-- require("jira.jira-fetch-issues-empty")
-- require("jira.jira-clone").setup()

-- vim.opt.completeopt = { "menu" }
vim.opt.completeopt = { "menu", "menuone" }

-- . = this buffer, w = from other windows, b = other loaded buffers
-- vim.opt.complete = { ".", "w", "b", "u" }
vim.opt.complete = { ".", "w", "b" }

-- local function smart_completion()
--   if vim.fn.pumvisible() == 1 then
--     -- If completion menu is visible, select next item
--     return "<C-n>"
--   else
--     -- If no menu is visible, trigger completion
--     return "<C-x><C-n>"
--   end
-- end

-- Map D-y or C-y to the smart completion function
-- if vim.fn.has("macunix") == 1 then
--   vim.api.nvim_set_keymap(
--     "i",
--     "<D-y>",
--     "v:lua.require('vim.lsp.util')._complete_done()",
--     { expr = true, noremap = true, silent = true }
--   )
--   vim.keymap.set("i", "<D-y>", function()
--     return smart_completion()
--   end, { expr = true, noremap = true, silent = true })
-- else
--   vim.keymap.set("i", "<C-y>", function()
--     return smart_completion()
--   end, { expr = true, noremap = true, silent = true })
-- end

-- Optional: Add mappings for navigating the completion menu
vim.api.nvim_set_keymap("i", "<C-j>", "pumvisible() ? '<C-n>' : '<C-j>'", { expr = true, noremap = true })
vim.api.nvim_set_keymap("i", "<C-k>", "pumvisible() ? '<C-p>' : '<C-k>'", { expr = true, noremap = true })

vim.cmd([[
function! CopyMatches(reg)
  let hits = []
  %s//\=len(add(hits, submatch(0))) ? submatch(0) : ''/gne
  let reg = empty(a:reg) ? '+' : a:reg
  execute 'let @'.reg.' = join(hits, "\n") . "\n"'
endfunction
command! -register Cm call CopyMatches(<q-reg>)
]])

-- disable blinking cursor
vim.opt.guicursor:append("a:blinkon0")
