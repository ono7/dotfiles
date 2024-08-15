vim.keymap.set("n", "<leader>f", "<cmd>lua vim.diagnostic.open_float()<cr>", { desc = "Open float" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

vim.diagnostic.config {
  float = { border = "rounded" },
}

local on_attach = function(client, bufnr)
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
  k("<space>l", "<cmd>lua vim.diagnostic.set_loclist()<CR>", "set_loclist")
  k("<space>i", "<cmd>lua vim.lsp.buf.implementation()<cr>", "implementation")
  k("<space>ca", vim.lsp.buf.code_action, "[<code action>]")
  k("go", vim.lsp.buf.type_definition, "[type definition]")
  k("gn", vim.lsp.buf.rename, "[R]e[n]ame")
end

local handle_lsp = function(opts1, override)
  if override ~= nil then
    -- force: keys from the far right table win during merge
    return vim.tbl_deep_extend("force", override, opts1)
  end
  return opts1
end

local cmp_nvim_lsp = require("cmp_nvim_lsp")

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
  ensure_installed = { "gopls",
    "pyright", "ansiblels",
    "html", "jsonls",
    "bashls", "terraformls",
    "cssls", "lua_ls",
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

-- Add cmp_nvim_lsp capabilities settings to lspconfig
-- nvim_lsp.util.default_config.capabilities = vim.tbl_deep_extend(
--   'force',
--   nvim_lsp.util.default_config.capabilities,
--   require('cmp_nvim_lsp').default_capabilities()
-- )

-- local capabilities = cmp_nvim_lsp.default_capabilities()
-- lua =vim.lsp.get_clients()[1].server_capabilities
-- local capabilities = cmp_nvim_lsp.default_capabilities(vim.lsp.protocol.make_client_capabilities())

-- HINT: P(capabilities) to inspect the client capabilities, this can then be modified

-- P(capabilities) -- see what the client supports
local capabilities = vim.lsp.protocol.make_client_capabilities()

-- make some changes
capabilities.textDocument.completion.completionItem.snippetSupport = true

--- check to see if the settings worked!
-- P(capabilities)

-- this could cause performace issues on big projects 2024-08-15 00:42
-- set to false until nevim 0.10.1 is updated
-- capabilities.workspace = {
--   didChangeWatchedFiles = {
--     dynamicRegistration = true,
--   },
-- }
--
-- print(vim.inspect(capabilities))
-- true needed for html/css

local lsp_opts = {
  root_dir = function(fname)
    return nvim_lsp.util.find_git_ancestor(fname)
  end,
  on_attach = on_attach,
  -- init_options = { hostInfo = "neovim" },
  capabilities = capabilities,
  flags = {
    allow_incremental_sync = true,
  },
}

nvim_lsp.gopls.setup({
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  autostart = true,
  root_dir = nvim_lsp.util.root_pattern("go.mod", "main.go", "go.work", ".git") or nvim_lsp.util.find_git_ancestor(fname),
  settings = {
    gopls = {
      completeUnimported = true,
      usePlaceholders = true,
      -- experimentalPostfixCompletions = true,
      analyses = {
        unusedparams = false,
        shadow = false,
      },
      staticcheck = true,
    },
  },
  on_attach = on_attach,
  capabilities = capabilities,
})

nvim_lsp.bashls.setup({})

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

require("lspconfig").terraformls.setup({
  root_dir = nvim_lsp.util.root_pattern("terraform.tfvars", "main.tf", ".git", "venv")
})

nvim_lsp.lua_ls.setup({
  Lua = {
    workspace = { checkThirdParty = false },
    telemetry = { enable = false },
    diagnostics = {
      globals = { "vim" },
    },
  },
})

nvim_lsp.cssls.setup(handle_lsp(lsp_opts))
nvim_lsp.html.setup {
  filetypes = { 'html' },
}

-- nvim_lsp.ansiblels.setup({
--   ansible = {
--     validation = {
--       lint = {
--         enabled = false
--       }
--     }
--   },
-- })
--

nvim_lsp.ansiblels.setup(handle_lsp(lsp_opts))

nvim_lsp.jsonls.setup(handle_lsp(lsp_opts))
