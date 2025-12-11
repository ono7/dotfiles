--- 🐇 Follow the white Rabbit...

--[[
http://vimcasts.org/categories/git/

find detected root dir

lua print(vim.lsp.get_clients({bufnr=0})[1].config.root_dir)

* view all compilers included with vim
:e $VIMRUNTIME/compiler
:compiler go
:make % or :make

* add all go files to arg list, :args **/*.go

* set dir to current open file, :cd %:h
* add all files to buff for faster navigation :argadd **/*.py
  * apply commands to open args list
    :sall
    :tab sall
    :argdo %s/test/Test/gc
* :write ++p (creates directories if they dont exists)

* neovim 0.11 defaults for lsp_attach

"grn" is mapped in Normal mode to |vim.lsp.buf.rename()|
"gra" is mapped in Normal and Visual mode to |vim.lsp.buf.code_action()|
"grr" is mapped in Normal mode to |vim.lsp.buf.references()|
"gri" is mapped in Normal mode to |vim.lsp.buf.implementation()|
"grt" is mapped in Normal mode to |vim.lsp.buf.type_definition()|
"gO" is mapped in Normal mode to |vim.lsp.buf.document_symbol()|
CTRL-S is mapped in Insert mode to |vim.lsp.buf.signature_help()|

* :s/foo/<Ctrl-R>0/g | replace with contents of unnamed reg 0
* use :b <part of buffer name><tab> to find open tags

redirect vim command output to registers

:redir @" | messages | redir end
:redir @a | execute 'lua =vim.lsp.get_clients()[1].server_capabilities.codeActionProvider' | redir END
:let @" = system('python3 ' . expand('%') . '--test=20')

-- encode contents of a register and save them back to the register

:let @" = system('base64', @")
:let @* = execute("message")

better workflow:
--- stores the output to a variable that can be assigned to a register

:redir => m
:do something
:do something else
:redir end
:let @" = m

then in normal mode: ""p

excellent way to make changes without crashing out completely

local ok, _ = pcall(vim.cmd, 'colorscheme ayu')
if not ok then
  vim.cmd 'colorscheme default' -- if the above fails, then use default
  vim.notify("colorscheme ayu failed")
end

-- get help
:set keywordprg=:help    " for vim help
:set keywordprg=pydoc    " for Python
:set keywordprg=man      " for Unix commands

mv 1.{bak,py} (1.bak -> 1.py) move filenames in shell, requires file.(src,dest)

use f,t,F,T vim, ; move forward (comma) move back

]]

vim.loader.enable(true)

if vim.opt.termguicolors then
  -- if truecolor is supported, lets make it better for neovim
  vim.cmd([[let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"]])
  vim.cmd([[let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"]])
end

vim.cmd("syntax off")

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
-- require("utils.help-lookup").setup()
require("utils.zoxide").setup() -- use fzflua zoxide..

--- these two worktogether
require("utils.runner").setup()      -- runs anything :M <cmd> :)
require("utils.runner-hook").setup() -- :H <cmd>  adds monitoring hook that triggers on file save
require("utils.ruff")

vim.opt.mouse = "a"

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

-- Ensure Go binaries are in PATH
local go_bin_path = vim.fn.expand("$HOME/go/bin")
local current_path = vim.env.PATH
if not string.find(current_path, go_bin_path, 1, true) then
  vim.env.PATH = go_bin_path .. ":" .. current_path
end

vim.notify("🐇 Follow the white rabbit...\nf,t,F,T (,;)")
vim.opt.guicursor = "n-c-v-i:block-Cursor"

-- vim.opt.guicursor = table.concat({
--   "n-v-c:block-Cursor", -- block
--   "i:ver25-Cursor",     -- beam (vertical bar, 25% width)
--   "r-cr:hor20-Cursor",  -- optional: thinner cursor for replace modes
-- }, ",")

-- vim.api.nvim_create_autocmd("FileType", {
--   group = vim.api.nvim_create_augroup("enable_syntax", { clear = true }),
--   pattern = "*",
--   callback = function()
--     -- allow these to have syntax enabled always
--     local allowed = {
--       markdown = true,
--       fugitive = true,
--       gitcommit = true,
--     }
--     if allowed[vim.bo.filetype] then
--       vim.cmd("setlocal syntax=on")
--     end
--   end,
-- })

-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "*",
--   callback = function()
--     -- allow these to have syntax enabled always
--     local allowed = {
--       markdown = true,
--       fugitive = true,
--       gitcommit = true,
--       toml = true,
--       config = true,
--     }
--     if not allowed[vim.bo.filetype] then
--       vim.cmd('setlocal syntax=off')
--     end
--   end
-- })

--- disable
vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    local no_syntax = {
      csv = true,
    }
    if no_syntax[vim.bo.filetype] then
      vim.treesitter.stop() -- stop treesitter for this buffer
      vim.cmd([[setlocal syntax=OFF]])
      vim.notify("All syntax off")
    end
  end,
})
