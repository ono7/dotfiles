local M = {}

M.toggle_lsp_for_buffer = function()
  local bufnr = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_clients({ bufnr = bufnr })

  if #clients > 0 then
    -- LSP is active, detach clients
    for _, client in ipairs(clients) do
      vim.lsp.buf_detach_client(bufnr, client.id)
    end
    vim.notify("LSP disabled for current buffer", vim.log.levels.INFO)
  else
    -- LSP is inactive, re-attach via filetype
    local ft = vim.bo[bufnr].filetype
    if ft ~= "" then
      vim.bo[bufnr].filetype = ft
      vim.notify("LSP enabled for current buffer", vim.log.levels.INFO)
    else
      vim.notify("No filetype set", vim.log.levels.WARN)
    end
  end
end

vim.keymap.set("n", "<leader>tl", M.toggle_lsp_for_buffer, { desc = "Toggle LSP for current buffer" })

M.setup = function()
  --- Global LSP configuration ---
  local ok, blink = pcall(require, "blink.cmp")

  vim.lsp.config("*", {
    root_markers = { ".git" },
    capabilities = ok and blink.get_lsp_capabilities() or nil,
  })

  if not ok then
    -- Ensure LSP omnifunc is enabled
    --- vim.bo.omnifunc = "v:lua.vim.lsp.omnifunc"

    -- <C-s> triggers native LSP completion
    vim.keymap.set("i", "<C-s>", function()
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-x><C-o>", true, false, true), "n", false)
    end, { noremap = true, silent = true })
  end

  --- Enable LSP servers ---
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

  --- Keymaps ---
  --- this is handled by blink.cmp by default
  vim.keymap.set("n", "K", function()
    vim.lsp.buf.hover({ border = "rounded" })
  end, { desc = "LSP: Hover documentation" })

  --- Completion options ---
  vim.o.completeopt = "menu,noinsert,popup,fuzzy"

  --- Diagnostic configuration ---
  vim.diagnostic.config({
    update_in_insert = false,
    virtual_text = false,
  })

  --- Diagnostic auto-management ---
  -- local diagnostic_group = vim.api.nvim_create_augroup("DiagnosticToggle", { clear = true })

  -- vim.api.nvim_create_autocmd("InsertEnter", {
  --   group = diagnostic_group,
  --   callback = function()
  --     vim.diagnostic.enable(false)
  --   end,
  -- })
  --
  -- vim.api.nvim_create_autocmd({ "InsertLeave", "BufWritePost" }, {
  --   group = diagnostic_group,
  --   callback = function()
  --     vim.diagnostic.enable(true)
  --   end,
  -- })
end

M.no_lsp = function()
  -- Placeholder for configs that don't need LSP
end

return M
