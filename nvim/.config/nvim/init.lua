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

use /<c-r><c-w> will fill in the word under the cursor, same with ?<c-r><c-w>

:%bd (close all buffers)

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

mv 1.{bak,py} (1.bak -> 1.py) move filenames in shell, requires file.(src,dest)

c-w + x -- swap splits in vim with next adjacent window

c-/  show/close quickfix list
c-q show diagnostic errors in quickfix list

use c-s and c-r more often to move around

<leader>nq - sets noqa for the particular diagnostics error

]]

-- Enable byte-compile loader immediately for performance
vim.loader.enable(true)

local large_file_group = vim.api.nvim_create_augroup("LargeFileOpts", { clear = true })
local threshold_bytes = 1048576

vim.api.nvim_create_autocmd("BufReadPre", {
  group = large_file_group,
  callback = function(args)
    local ok, stat = pcall(vim.uv.fs_stat, args.match)
    if ok and stat and stat.size > threshold_bytes then
      vim.b[args.buf].large_file = true
      vim.bo[args.buf].swapfile = false
      vim.bo[args.buf].undofile = false

      -- Temporarily blackhole the FileType event for this buffer load
      vim.opt.eventignore:append("FileType")
    end
  end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
  group = large_file_group,
  callback = function(args)
    if not vim.b[args.buf].large_file then
      return
    end

    -- Immediately restore FileType event generation for other buffers
    vim.opt.eventignore:remove("FileType")

    vim.bo[args.buf].filetype = ""
    vim.bo[args.buf].syntax = ""
    vim.bo[args.buf].matchpairs = ""

    local win = vim.fn.bufwinid(args.buf)
    if win ~= -1 then
      vim.wo[win].wrap = false
      vim.wo[win].foldmethod = "manual"
      vim.wo[win].cursorline = false
      vim.wo[win].cursorcolumn = false
    end

    -- Force-detach LSPs as a safety net
    for _, client in ipairs(vim.lsp.get_clients({ bufnr = args.buf })) do
      vim.lsp.buf_detach_client(args.buf, client.id)
    end
  end,
})

if vim.opt.termguicolors then
  -- if truecolor is supported, lets make it better for neovim
  vim.cmd([[let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"]])
  vim.cmd([[let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"]])
end

-- Ensure syntax is ON by default so Treesitter can handoff or fall back
vim.cmd("syntax on")

-- new for 0.12.0
-- 1. Enable the new non-blocking UI to kill "Press ENTER" prompts
-- if pcall(require, "vim._core.ui2") then require("vim._core.ui2").enable() end

require("config.keymaps")
require("config.options")
require("config.disabled")
require("config.legacy")
require("config.abbreviations")
require("config.diff-settings")
require("config.vars")
-- require("config.helper-functions")
require("config.lazy")
-- require("utils.change-path").setup() -- :Cd (toggle root dir and cwd)
-- require("utils.create-table").setup()
require("config.commands")
require("config.autocmds")
require("config.lsp").setup()
require("config.neovide")
require("utils.zoxide").setup() -- use fzflua zoxide..

--- these two worktogether

-- require("utils.runner").setup() -- runs anything :M <cmd> :)
-- require("utils.runner-hook").setup() -- :H <cmd>  adds monitoring hook that triggers on file save
require("utils.projects").setup() -- keeps track of project
-- require("utils.ruff")

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
if vim.fn.isdirectory(go_bin_path) == 1 then
  local current_path = vim.env.PATH
  if not string.find(current_path, go_bin_path, 1, true) then
    vim.env.PATH = go_bin_path .. ":" .. current_path
  end
end

--- disable
vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function(args)
    local no_syntax = {
      csv = true,
      log = true,
    }
    if no_syntax[vim.bo[args.buf].filetype] then
      pcall(vim.treesitter.stop, args.buf)
      vim.bo[args.buf].syntax = "off"
      vim.notify("Syntax and Treesitter disabled for " .. vim.bo[args.buf].filetype)
    end
  end,
})

-- Enable blinking cursor in Neovide (and other GUIs)
vim.opt.guicursor =
  "n-v-c:block-blinkwait0-blinkoff400-blinkon250-Cursor/Cursor,i-ci-ve:ver25-blinkwait0-blinkoff400-blinkon250-Cursor/Cursor"

vim.diagnostic.config({ update_in_insert = false })

--- remove "press ENTER" prompt.. maybe
-- if pcall(require, "vim._core.ui2") then require("vim._core.ui2").enable({}) end
