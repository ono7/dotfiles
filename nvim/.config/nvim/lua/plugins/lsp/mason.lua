vim.keymap.set("n", "<leader>f", "<cmd>lua vim.diagnostic.open_float()<cr>", { desc = "Open float" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

vim.diagnostic.config {
  float = { border = "rounded" },
}

local on_attach = function(client, bufnr)
  if client.nam == "lua_ls" then
    -- disable hl groups created by lua ls
    client.server_capabilities.semanticTokensProvider = nil
  end
  if client.name == 'ruff_lsp' then
    -- Disable hover in favor of Pyright
    client.server_capabilities.hoverProvider = false
  end
  local k = function(keys, func, desc)
    if desc then
      desc = "LSP: " .. desc
    end
    vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
  end

  k("gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", "[G]oto [D]eclaration")
  k("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
  k("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
  k("K", vim.lsp.buf.hover, "Hover Documentation")
  k("<m-k>", vim.lsp.buf.signature_help, "Signature help")
  k("<space>l", "<cmd>lua vim.diagnostic.set_loclist()<CR>", "set_loclist")
  -- k("<space>i", "<cmd>lua vim.lsp.buf.implementation()<cr>", "implementation")
  k("<space>ca", vim.lsp.buf.code_action, "[<code action>]")
  k("go", vim.lsp.buf.type_definition, "[type definition]")
  k("gn", vim.lsp.buf.rename, "[R]e[n]ame")
end

-- vim.api.nvim_set_keymap('i', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', {noremap = true, silent = true})

local mason_status, mason = pcall(require, "mason")

if not mason_status then
  print("mason not loaded in cmp.lua")
  return
end

mason.setup()

local mason_lspconfig_status, mason_lspconfig = pcall(require, "mason-lspconfig")

if not mason_lspconfig_status then
  print("mason_lspconfig not loaded in cmp.lua")
  return
end

mason_lspconfig.setup({
  ensure_installed = {
    "gopls",
    "pyright",
    "ansiblels",
    "html",
    "jsonls",
    "bashls",
    "terraformls",
    "cssls",
    "lua_ls",
    "ruff_lsp",
  }
})

local neodev_ok, neodev_config = pcall(require, "neodev")

if not neodev_ok then
  print("Error in pcall neodev -> ~/.dotfiles/nvim/lua/plugins/lsp/mason.lua")
  return
end

neodev_config.setup({
  library = { plugins = { "nvim-dap-ui" }, types = true }
})

local nvim_lsp_status, nvim_lsp = pcall(require, "lspconfig")

if not nvim_lsp_status then
  print("lspconfig not loaded in cmp.lua")
  return
end

-- HINT: P(capabilities) to inspect the client capabilities, this can then be modified

-- P(capabilities) -- see what the client supports
local capabilities = vim.lsp.protocol.make_client_capabilities()

-- make some changes
capabilities.textDocument.completion.completionItem.snippetSupport = false

-- this could create performace problems on big projects, best disabled for now
capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = false
-- P(capabilities)

-- expand lsp opts and return new table of options
local extend_opts = function(opts1, override)
  if override ~= nil then
    return vim.tbl_deep_extend("force", override, opts1)
  end
  return opts1
end

-- standard lsp options
local lsp_opts = {
  on_attach = on_attach,
  capabilities = capabilities,
}

-- standard server setup

nvim_lsp.gopls.setup(lsp_opts)
nvim_lsp.bashls.setup(lsp_opts)
nvim_lsp.cssls.setup(lsp_opts)
nvim_lsp.html.setup(lsp_opts)
nvim_lsp.ansiblels.setup(lsp_opts)
nvim_lsp.jsonls.setup(lsp_opts)

-- custom servers go here

-- python
nvim_lsp.pyright.setup {
  on_attach = on_attach,
  root_dir = nvim_lsp.util.root_pattern("venv", "requirements.txt", "setup.py", ".git"),
  settings = {
    pyright = {
      autoImportCompletion = true,
      disableOrganizeImports = true
    },
    python = {
      analysis = {
        autoSearchPaths = true,
        diagnosticMode = 'openFilesOnly',
        useLibraryCodeForTypes = true,
        typeCheckingMode = 'off', -- 'basic'
        -- ignore = { '*' },
      }
    }
  }
}


-- terraform
local tf_opts = {
  root_dir = nvim_lsp.util.root_pattern("terraform.tfvars", "main.tf", ".git", "venv")
}
require("lspconfig").terraformls.setup(extend_opts(lsp_opts, tf_opts))

-- lua
nvim_lsp.lua_ls.setup({
  Lua = {
    workspace = { checkThirdParty = false },
    telemetry = { enable = false },
    diagnostics = {
      globals = { "vim" },
    },
  },
  on_attach = on_attach,
  capabilities = capabilities
})
