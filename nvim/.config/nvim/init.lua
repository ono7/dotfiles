--- 🐇 Follow the white Rabbit...

--[[
http://vimcasts.org/categories/git/

* view all compilers included with vim
:e $VIMRUNTIME/compiler
:compiler go
:make % or :make

fugitive:
  stage and commits file all at once :G commit % -m "abc"

* add all go files to arg list, :args **/*.go

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

-- require("old_plugins.jira-base")
-- require("jira.jira")
-- require("jira.jira-move")
-- require("jira.jira-fetch-issues")
-- require("jira.jira-fetch-issues-empty")
-- require("jira.jira-clone").setup()

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

vim.opt.guicursor:append("a:blinkon0")
vim.opt.mouse = "a"
vim.opt.guicursor = ""
vim.opt.completeopt = { "menu", "menuone" }
-- . = this buffer, w = from other windows, b = other loaded buffers
vim.opt.complete = { ".", "w", "b" }

--- check to see what autocmds are running on the buffer
--- usefull for fixing performance issues or input issues
vim.api.nvim_create_user_command("CheckAutocommands", function()
  local events =
    { "InsertEnter", "InsertLeave", "InsertCharPre", "TextChanged", "TextChangedI", "CursorHold", "CursorHoldI" }

  for _, event in ipairs(events) do
    local autocmds = vim.api.nvim_get_autocmds({ event = event })
    if #autocmds > 0 then
      print("Event:", event, "- Count:", #autocmds)
      for i, autocmd in ipairs(autocmds) do
        if i <= 3 then
          print("  ", autocmd.group or "no group", autocmd.desc or autocmd.command or "no desc")
        elseif i == 4 then
          print("  ... and", #autocmds - 3, "more")
          break
        end
      end
    end
  end
end, {})
