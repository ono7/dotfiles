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

vim.opt.completeopt = { "menu", "menuone" }
vim.opt.complete = { ".", "w", "b" }
vim.cmd([[syntax off ]])

if vim.opt.termguicolors then
  -- if truecolor is supported, lets make it better for neovim
  vim.cmd([[let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"]])
  vim.cmd([[let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"]])
end

require("config.options")
require("config.keymaps")
require("config.disabled")
require("config.legacy")
require("config.abbreviations")
require("config.diff-settings")
require("config.vars")
require("config.helper-functions")
require("config.lazy")
-- require("utils.change-path").setup() -- :Cd (toggle root dir and cwd)
require("utils.create-table").setup()
require("config.commands")
require("config.autocmds")
require("config.lsp").setup()
require("config.neovide")
-- require("utils.help-lookup").setup()
require("utils.zoxide").setup()

--- these two worktogether
require("utils.runner").setup()      -- runs anything :M <cmd> :)
require("utils.runner-hook").setup() -- :H <cmd>  adds monitoring hook that triggers on file save
require("utils.ruff")

-- Optional: Add mappings for navigating the completion menu
vim.api.nvim_set_keymap("i", "<C-j>", "pumvisible() ? '<C-n>' : '<C-j>'", { expr = true, noremap = true })
vim.api.nvim_set_keymap("i", "<C-k>", "pumvisible() ? '<C-p>' : '<C-k>'", { expr = true, noremap = true })

vim.opt.mouse = "a"
vim.opt.guicursor = ""

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
vim.opt.guicursor = "n-c-v-i:block-Cursor"

vim.api.nvim_set_hl(0, "MatchParen", { bg = "#5a6b85", bold = true, italic = false })

vim.cmd("syntax off")

vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    -- allow these to have syntax enabled always
    local allowed = {
      markdown = true,
      fugitive = true,
      -- toml = true,
      -- config = true,
    }
    if allowed[vim.bo.filetype] then
      vim.cmd('setlocal syntax=on')
    end
  end
})

vim.opt.showtabline = 1
vim.opt.tabline = '%!v:lua.MyTabLine()'

local opt = { noremap = true }
vim.keymap.set('n', '<C-1>', '1gt', opt)
vim.keymap.set('n', '<C-2>', '2gt', opt)
vim.keymap.set('n', '<C-3>', '3gt', opt)
vim.keymap.set('n', '<C-4>', '4gt', opt)
vim.keymap.set('n', '<C-5>', '5gt', opt)
vim.keymap.set('n', '<C-6>', '6gt', opt)
vim.keymap.set('n', '<C-7>', '7gt', opt)
vim.keymap.set('n', '<C-8>', '8gt', opt)
vim.keymap.set('n', '<C-9>', '9gt', opt)

function _G.MyTabLine()
  local s = ''
  for i = 1, vim.fn.tabpagenr('$') do
    local winnr = vim.fn.tabpagewinnr(i)
    local bufnr = vim.fn.tabpagebuflist(i)[winnr]
    local bufname = vim.fn.bufname(bufnr)
    local filename = bufname ~= '' and vim.fn.fnamemodify(bufname, ':t') or '[No Name]'

    if i == vim.fn.tabpagenr() then
      s = s .. '%#TabLineSel#'
    else
      s = s .. '%#TabLine#'
    end

    s = s .. ' ' .. i .. ':' .. filename .. ' '
  end

  s = s .. '%#TabLineFill#'
  return s
end

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

-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "*",
--   callback = function()
--     local allowed = {
--       markdown = true,
--       vim = true,
--       fugitive = true,
--       gitcommit = true,
--     }
--     if not allowed[vim.bo.filetype] then
--       vim.treesitter.stop() -- stop treesitter for this buffer
--     end
--   end
-- })

vim.cmd([[hi! link MatchParen TermCursor]])
