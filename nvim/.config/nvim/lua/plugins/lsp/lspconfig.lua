return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "folke/neodev.nvim",
      "onsails/lspkind-nvim",
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      -- use LspAttach hook
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
        callback = function(ev)
          local ks = vim.keymap.set
          local opts = { buffer = ev.buf, silent = true }
          local k = function(keys, func, desc)
            if desc then
              desc = "LSP: " .. desc
            end
            vim.keymap.set("n", keys, func, { buffer = ev.buf, silent = true, desc = desc })
          end

          k("gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", "Goto LSP Declaration")
          k("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
          k("gr", require("telescope.builtin").lsp_references, "Goto LSP References")
          k("gi", require("telescope.builtin").lsp_implementations, "Goto LSP Implementations")
          k("K", vim.lsp.buf.hover, "Hover Documentation")
          k("<m-k>", vim.lsp.buf.signature_help, "Signature help")
          -- k("<space>ll", "<cmd>lua vim.diagnostic.set_loclist()<CR>", "set_loclist")
          -- k("<space>i", "<cmd>lua vim.lsp.buf.implementation()<cr>", "implementation")

          opts.desc = "code action"
          ks({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, opts)

          opts.desc = "Restart LSP"
          ks("n", "<leader>rs", ":LspRestart<cr>", opts)

          k("go", vim.lsp.buf.type_definition, "[type definition]")
          k("gn", vim.lsp.buf.rename, "[R]e[n]ame")
        end,
      })

      -- TODO: move this to its own section
      vim.keymap.set("n", "<leader>f", "<cmd>lua vim.diagnostic.open_float()<cr>", { desc = "Open float" })
      vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

      vim.diagnostic.config({
        float = { border = "rounded" },
      })

      -- view defined symbols :echo sign_getdefined()
      vim.fn.sign_define("DiagnosticSignInfo", { text = "", texthl = "ModeMsg" })
      vim.fn.sign_define("DiagnosticSignError", { text = "", texthl = "Error" })
      vim.fn.sign_define("DiagnosticSignHint", { text = "", texthl = "Normal" })
      vim.fn.sign_define("DiagnosticSignWarn", { text = "", texthl = "CursorLineNr" })
      vim.fn.sign_define("DiagnosticsVirtualTextHint", { text = "", texthl = "Normal" })
      -- vim.api.nvim_set_keymap('i', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', {noremap = true, silent = true})

      -- virtual text
      vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
        signs = true,
        -- virtual_text = {
        --   spacing = 2,
        --   -- severity_limit = "Warning", -- disable hints...
        --   severity = { min = vim.diagnostic.severity.WARN },
        --   underline = true,
        -- },
        virtual_text = false,
        virtual_lines = { only_current_line = true },
        update_in_insert = false,
        underline = true,
      })

      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })

      vim.lsp.handlers["textDocument/signatureHelp"] =
        vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })

      local on_attach = function(client, bufnr)
        if client.name == "lua_ls" then
          -- disable hl groups created by lua ls
          client.server_capabilities.semanticTokensProvider = nil

          -- for _, group in ipairs(vim.fn.getcompletion("@lsp", "highlight")) do
          --   vim.api.nvim_set_hl(0, group, {})
          -- end
        end

        if client.name == "ruff_lsp" then
          -- Disable hover in favor of Pyright
          client.server_capabilities.hoverProvider = false
        end
      end

      local neodev_ok, neodev_config = pcall(require, "neodev")

      if not neodev_ok then
        print("Error in pcall neodev -> ~/.dotfiles/nvim/lua/plugins/lsp/mason.lua")
        return
      end

      neodev_config.setup({
        library = { plugins = { "nvim-dap-ui" }, types = true },
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
      nvim_lsp.ts_ls.setup(lsp_opts)
      nvim_lsp.ansiblels.setup(lsp_opts)
      -- nvim_lsp.jsonls.setup(lsp_opts)

      -- custom servers go here

      -- python
      nvim_lsp.pyright.setup({
        on_attach = on_attach,
        -- root_dir = nvim_lsp.util.root_pattern("venv", "requirements.txt", "setup.py", ".git"),
        root_dir = vim.fs.root(0, ".git"),
        settings = {
          pyright = {
            autoImportCompletion = true,
            disableOrganizeImports = true,
          },
          python = {
            analysis = {
              autoSearchPaths = true,
              diagnosticMode = "openFilesOnly",
              useLibraryCodeForTypes = true,
              typeCheckingMode = "off", -- 'basic'
              -- ignore = { '*' },
            },
          },
        },
      })

      -- terraform
      local tf_opts = {
        -- root_dir = nvim_lsp.util.root_pattern("terraform.tfvars", "main.tf", ".git", "venv"),
        root_dir = vim.fs.root(0, ".git"),
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
        capabilities = capabilities,
      })
    end,
  },
}
