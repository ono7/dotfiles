local M = {}

M.setup = function()
  local silent = { noremap = true, silent = true }

  local borders = {
    source = "if_many",
    border = {
      "╭",
      "─",
      "╮",
      "│",
      "╯",
      "─",
      "╰",
      "│",
    },
  }

  --- lsp config ---
  -- this will get merged with the lsp/*.lua files
  -- conviniently making some settings global
  vim.lsp.config("*", {
    root_markers = { ".git" },
    capabilities = {
      textDocument = {
        semanticTokens = {
          multilineTokenSupport = true,
        },
      },
    },
  })

  -- get the lsp client resolved configuration
  -- :lua P(vim.lsp.config.luals)

  -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
  -- configure under lsp/*.lua
  vim.lsp.enable({
    "gopls",
    "pyright",
    "ansiblels",
    "luals",
    "bashls",
    "html",
    "jsonls",
    "eslint",
    "ts_ls",
    "terraformls",
    "cssls",
    "ruff",
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

  -- <C-d> for telescope diagnostics
  vim.diagnostic.config({ virtual_text = { current_line = true } })

  -- vim.diagnostic.config({ virtual_text = false })

  vim.keymap.set("n", "<leader>f", function()
    vim.diagnostic.open_float(borders)
  end, { desc = "Open float" })

  vim.keymap.set("n", "K", function()
    vim.lsp.buf.hover({ borders })
  end, { desc = "Open documentation" })

  --- completion ---
  vim.o.completeopt = "menu,noinsert,popup,fuzzy"
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(ev)
      -- manual trigger
      vim.keymap.set("i", "<C-Space>", function()
        vim.lsp.completion.get()
      end)

      vim.keymap.set("n", "[d", function()
        -- goto prev
        vim.diagnostic.jump({ count = -1, float = borders, wrap = true })
      end, silent)

      vim.keymap.set("n", "]d", function()
        -- goto next
        vim.diagnostic.jump({ count = 1, float = borders, wrap = true })
      end, silent)

      local client = vim.lsp.get_client_by_id(ev.data.client_id)
      if not client then
        return
      end
      if client:supports_method("textDocument/completion") then
        client.server_capabilities.completionProvider.triggerCharacters = vim.split(".", "", true)

        vim.lsp.completion.enable(true, client.id, ev.buf, {
          autotrigger = false,
          convert = function(item)
            return { abbr = item.label:gsub("%b()", "") }
          end,
        })
      end
    end,
  })

  -- select first option in complete menu, works in cmp or without keywords
  vim.api.nvim_set_keymap("i", "<C-y>", [[<C-n><c-p>]], silent)
end

M.no_lsp = function()
  vim.opt.completeopt = { "longest" }
  vim.opt.complete = { ".", "w", "b", "u" }
  -- Map Ctrl-Y to trigger completion and auto-select
  if vim.loop.os_uname().sysname == "Darwin" then
    vim.api.nvim_set_keymap("i", "<D-y>", [[<C-n><c-p>]], { noremap = true, silent = true })
  else
    vim.api.nvim_set_keymap("i", "<C-y>", [[<C-n><c-p>]], { noremap = true, silent = true })
  end
end
return M
