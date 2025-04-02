--- 🐇 Follow the white Rabbit...
-- :write ++p (creates directories if they dont exists)
local opt = { noremap = true }

vim.cmd([[syntax off]])

if vim.opt.termguicolors then
  -- if truecolor is supported, lets make it better for neovim
  vim.cmd([[let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"]])
  vim.cmd([[let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"]])
end

vim.g.syntax_on = false
vim.opt.syntax = "off"

require("config.neovide")
require("config.options")
require("config.keymaps")
require("config.disabled")
require("config.legacy")
require("config.abbreviations")
require("config.diff-settings")
require("config.vars")
require("config.helper-functions")
require("config.lazy")
require("utils.zoxide").setup()
require("utils.runner").setup()      -- runs anything :M <cmd> :)
require("utils.runner-hook").setup() -- :H <cmd>  adds monitoring hook that triggers on file save
require("utils.create-table").setup()
require("config.commands")
require("config.autocmds")
require("config.completion")
require("config.mason")
require("utils.help-lookup").setup()

if vim.g.neovide then
  --- vsync = true for smooth cursor movement, which is why we are here
  -- vim.api.nvim_set_hl(0, "Normal", { bg = "#1b1f31", fg = "#b8c1e6" })

  -- vim.api.nvim_set_hl(0, "Normal", { bg = "#1a1f32", fg = "#b8c1e6" })
  vim.api.nvim_set_hl(0, "Normal", { bg = "#1a1f32", fg = "#a8b5d1" })

  -- Map Cmd+g to Ctrl+g in multiple modes

  vim.keymap.set({ "i", "n", "v", "x" }, "<D-g>", "<C-g>")

  vim.keymap.set({ "c", "n" }, "<D-p>", "<C-p>")
  vim.keymap.set({ "c", "n" }, "<D-n>", "<C-n>")

  -- vim.keymap.set("i", "<D-p>", "<C-p>") -- Insert mode
  -- vim.keymap.set("i", "<D-n>", "<C-n>") -- Insert mode

  -- Regular increment/decrement
  vim.keymap.set("n", "<D-x>", "<c-x>", opt)

  -- Visual mode increment/decrement
  vim.keymap.set("x", "<D-a>", "g<C-a>", opt)
  vim.keymap.set("x", "<D-x>", "g<C-x>", opt)
  vim.keymap.set("n", "<D-a>", "<C-a>")

  vim.keymap.set("n", "<D-V>", '"+p', { noremap = true })    -- Normal mode
  vim.keymap.set("i", "<D-V>", "<C-R>+", { noremap = true }) -- Insert mode
  vim.keymap.set("c", "<D-V>", "<C-R>+", { noremap = true }) -- Insert mode
  vim.keymap.set("v", "<D-V>", '"+p', { noremap = true })    -- Visual mode
  vim.keymap.set("t", "<D-V>", '<C-\\><C-N>"+pi', { noremap = true })
end

vim.opt.mouse = "a"

-- block cursor
vim.opt.guicursor = ""

-- require("old_plugins.jira-base")
require("jira.jira")
require("jira.jira-move")
require("jira.jira-fetch-issues")
require("jira.jira-fetch-issues-empty")
require("jira.jira-clone").setup()

--- lsp config

-- this will get merged with the lsp/*.lua files
-- conviniently making some settings global
vim.lsp.config("*", {
  capabilities = {
    textDocument = {
      semanticTokens = {
        multilineTokenSupport = true,
      },
    },
  },
  root_markers = { ".git" },
})

vim.lsp.enable({ "gopls", "pyright", "ansiblels", "luals" })

vim.diagnostic.config({
  virtual_text = { current_line = true },
  virtual_lines = {
    -- Only show virtual line diagnostics for the current cursor line
    current_line = true,
  },
})

vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "",
      [vim.diagnostic.severity.WARN] = "",
      [vim.diagnostic.severity.INFO] = "",
      [vim.diagnostic.severity.HINT] = "",
    },
    numhl = {
      [vim.diagnostic.severity.WARN] = "WarningMsg",
      [vim.diagnostic.severity.ERROR] = "ErrorMsg",
      [vim.diagnostic.severity.INFO] = "DiagnosticInfo",
      [vim.diagnostic.severity.HINT] = "DiagnosticHint",
    },
  },
})

-- auto completion and autoformat
-- vim.api.nvim_create_autocmd("LspAttach", {
--   group = vim.api.nvim_create_augroup("my.lsp", {}),
--   callback = function(args)
--     local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
--     -- if client:supports_method("textDocument/implementation") then
--     -- Create a keymap for vim.lsp.buf.implementation ...
--     -- end
--
--     -- Enable auto-completion. Note: Use CTRL-Y to select an item. |complete_CTRL-Y|
--     if client:supports_method("textDocument/completion") then
--       -- Optional: trigger autocompletion on EVERY keypress. May be slow!
--       -- local chars = {}; for i = 32, 126 do table.insert(chars, string.char(i)) end
--       -- client.server_capabilities.completionProvider.triggerCharacters = chars
--
--       vim.keymap.set("i", "<c-space>", function()
--         vim.lsp.completion.get()
--       end)
--
--       vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
--
--       if client.server_capabilities.completionProvider then
--         client.server_capabilities.completionProvider.triggerCharacters = { ".", ":", ">", "(" } -- Example trigger characters
--       end
--     end
--
--     -- Auto-format ("lint") on save.
--     -- Usually not needed if server supports "textDocument/willSaveWaitUntil".
--     if
--         not client:supports_method("textDocument/willSaveWaitUntil")
--         and client:supports_method("textDocument/formatting")
--     then
--       vim.api.nvim_create_autocmd("BufWritePre", {
--         group = vim.api.nvim_create_augroup("my.lsp", { clear = false }),
--         buffer = args.buf,
--         callback = function()
--           vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000 })
--         end,
--       })
--     end
--   end,
-- })

-- -- map <cr> to <c-y> when the popup menu is visible
-- vim.keymap.set("i", "<cr>", "pumvisible() ? '<c-y>' : '<cr>'", { expr = true })
