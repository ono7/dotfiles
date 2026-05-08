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

show/close quickfix list c-/

]]

-- Enable byte-compile loader immediately for performance
vim.loader.enable(true)

local large_file_group = vim.api.nvim_create_augroup("LargeFileOptimization", { clear = true })
local threshold_bytes = 1048576 -- 1MB threshold

-- Intercept file read to prevent swapfile generation blocking the main thread
vim.api.nvim_create_autocmd("BufReadPre", {
  group = large_file_group,
  callback = function(args)
    local ok, stat = pcall(vim.uv.fs_stat, args.match)
    if ok and stat and stat.size > threshold_bytes then
      vim.bo[args.buf].swapfile = false
      vim.bo[args.buf].undofile = false
    end
  end,
})

-- Execute UI optimization, parser termination, and LSP detachment post-read
vim.api.nvim_create_autocmd("BufReadPost", {
  group = large_file_group,
  callback = function(args)
    local buf = args.buf
    local ok, stat = pcall(vim.uv.fs_stat, args.match)

    if ok and stat and stat.size > threshold_bytes then
      -- 1. Disable expensive UI rendering and line-wrap calculations
      vim.wo[0].wrap = false
      vim.wo[0].foldmethod = "manual"
      vim.wo[0].spell = false
      vim.wo[0].list = false
      vim.wo[0].cursorline = false
      vim.wo[0].cursorcolumn = false
      vim.wo[0].colorcolumn = ""

      vim.bo[buf].syntax = "off"
      vim.bo[buf].swapfile = false
      vim.bo[buf].undofile = false
      vim.bo[buf].synmaxcol = 200
      vim.b[buf].disable_autoformat = true
      vim.b[buf].large_file = true -- Mark as optimized, use this later on other plugins to skip them
      vim.b[buf].lsp_ignore = true

      if pcall(require, "matchparen") then
        pcall(function()
          require("matchparen").disable(buf)
        end)
      end

      -- 2. Disable bracket matching across massive lines
      vim.bo[buf].matchpairs = ""

      -- 3. Terminate Treesitter parsing for the buffer
      local has_ts, ts_highlighter = pcall(require, "vim.treesitter.highlighter")
      if has_ts and ts_highlighter.active[buf] then
        vim.treesitter.stop(buf)
      end

      -- 4. Detach all active LSP clients
      for _, client in ipairs(vim.lsp.get_clients({ bufnr = buf })) do
        vim.lsp.buf_detach_client(buf, client.id)
      end

      -- 5. Set global buffer flag to instruct compliant plugins to back off
      vim.b[buf].large_file = true
      vim.notify("Large file detected: Performance optimizations applied.", vim.log.levels.WARN)
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
if package.searchpath("config.lsp", package.path) then
  require("config.lsp").setup()
end
require("config.neovide")
if package.searchpath("utils.zoxide", package.path) then
  require("utils.zoxide").setup() -- use fzflua zoxide..
end

--- these two worktogether

-- require("utils.runner").setup() -- runs anything :M <cmd> :)
-- require("utils.runner-hook").setup() -- :H <cmd>  adds monitoring hook that triggers on file save
if package.searchpath("utils.projects", package.path) then
  require("utils.projects").setup() -- keeps track of project
end
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
