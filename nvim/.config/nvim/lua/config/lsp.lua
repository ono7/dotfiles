local M = {}

M.toggle_lsp_for_buffer = function()
  local bufnr = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_clients({ buffer = bufnr })
  if #clients > 0 then
    -- LSP is active, disable it
    for _, client in ipairs(clients) do
      client:stop()
    end
    vim.notify("LSP disabled for current buffer")
  else
    -- LSP is inactive, enable it
    -- Re-enable by re-triggering filetype detection
    local ft = vim.bo[bufnr].filetype
    vim.cmd("set filetype=" .. ft)
    vim.notify("LSP enabled for current buffer")
  end
end

vim.keymap.set("n", "<leader>tl", M.toggle_lsp_for_buffer, { desc = "Toggle LSP for current buffer" })

M.setup = function()
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

  vim.keymap.set("n", "K", function()
    vim.lsp.buf.hover({ border = "rounded" })
  end, { desc = "Open documentation" })

  --- completion ---
  vim.o.completeopt = "menu,noinsert,popup,fuzzy"

  vim.diagnostic.config({
    update_in_insert = false,
    virtual_text = false
  })

  --- enable on enter
  vim.api.nvim_create_autocmd({ "BufReadPost", "BufEnter" }, {
    callback = function()
      vim.diagnostic.enable(true)
    end,
  })

  vim.api.nvim_create_autocmd("BufWritePost", {
    callback = function()
      if not vim.diagnostic.is_enabled() then
        vim.diagnostic.enable(true)
      end
    end,
  })

  vim.api.nvim_create_autocmd("InsertEnter", {
    callback = function()
      if vim.diagnostic.is_enabled() then
        vim.diagnostic.enable(false)
      end
    end,
  })
end

M.no_lsp = function()
end

return M
