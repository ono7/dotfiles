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
require("utils.runner").setup() -- runs anything :M <cmd> :)
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

  vim.keymap.set("n", "<D-V>", '"+p', { noremap = true }) -- Normal mode
  vim.keymap.set("i", "<D-V>", "<C-R>+", { noremap = true }) -- Insert mode
  vim.keymap.set("c", "<D-V>", "<C-R>+", { noremap = true }) -- Insert mode
  vim.keymap.set("v", "<D-V>", '"+p', { noremap = true }) -- Visual mode
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

--- lsp config ---

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

vim.diagnostic.config({
  virtual_text = false,
  virtual_lines = {
    -- new diag implementation for 0.11, shows only text under the line
    current_line = true,
  },
})
--- completion ---
vim.o.completeopt = "menu,noinsert,popup,fuzzy"

local pumMaps = {
  ["<Tab>"] = "<C-n>",
  ["<S-Tab>"] = "<C-p>",
}
for insertKmap, pumKmap in pairs(pumMaps) do
  vim.keymap.set("i", insertKmap, function()
    return vim.fn.pumvisible() == 1 and pumKmap or insertKmap
  end, { expr = true })
end

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client:supports_method("textDocument/completion") then
      -- Default triggerCharacters is dot only { "." }
      client.server_capabilities.completionProvider.triggerCharacters = vim.split(".", "", true)

      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = false })
    end
  end,
})

-- trigger complete once in buffer
vim.keymap.set("i", "<c-space>", function()
  vim.lsp.completion.get()
end)
