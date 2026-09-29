local M = {}

--- Toggle LSP for the current buffer
M.toggle_lsp_for_buffer = function()
  local bufnr = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_clients({ bufnr = bufnr })

  if #clients > 0 then
    for _, client in ipairs(clients) do
      vim.lsp.buf_detach_client(bufnr, client.id)
    end
    vim.wo[0].winbar = ""
    vim.notify("LSP disabled for buffer", vim.log.levels.INFO)
  else
    local ft = vim.bo[bufnr].filetype
    if ft ~= "" then
      -- NOTE(jlima): Resetting filetype deterministically triggers filetype autocmds to re-attach LSPs
      vim.bo[bufnr].filetype = ft
      vim.notify("LSP re-enabled for buffer", vim.log.levels.INFO)
    end
  end
end

vim.keymap.set("n", "<leader>tl", M.toggle_lsp_for_buffer, { desc = "Toggle LSP for buffer" })

M.setup = function()
  --- 1. Global LSP configuration ---
  vim.lsp.config("*", {
    root_markers = { ".git" },
  })

  --- 2. Buffer LSP Attachment ---
  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspAttach", { clear = true }),
    callback = function(args)
      -- NOTE(jlima): Set omnifunc natively on attach; Navic redraw loops removed
      vim.bo[args.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
    end,
  })

  --- 3. Smart Completion Trigger (<C-l>) ---
  vim.keymap.set("i", "<C-l>", function()
    local clients = vim.lsp.get_clients({ bufnr = 0 })
    return #clients > 0 and "<C-x><C-o>" or "<C-x><C-n>"
  end, { expr = true, replace_keycodes = true, desc = "Smart Completion" })

  --- 4. Enable LSP servers ---
  vim.lsp.enable({
    "gopls",
    "pyright",
    "ansiblels",
    "luals",
    "qmlls",
    "bashls",
    "html",
    "jsonls",
    "eslint",
    "ts_ls",
    "terraformls",
    "cssls",
    "ruff",
  })

  --- 5. Completion & Diagnostic Presentation ---
  vim.o.completeopt = "menuone,fuzzy"

  vim.diagnostic.config({
    update_in_insert = false,
    virtual_text = false,
    severity_sort = true,
    float = { border = "rounded" },
  })

  --- 6. Diagnostic Auto-management ---
  local diagnostic_group = vim.api.nvim_create_augroup("DiagnosticToggle", { clear = true })

  vim.api.nvim_create_autocmd("InsertEnter", {
    group = diagnostic_group,
    callback = function()
      vim.diagnostic.enable(false)
    end,
  })

  vim.api.nvim_create_autocmd({ "InsertLeave", "BufWritePost" }, {
    group = diagnostic_group,
    callback = function()
      vim.diagnostic.enable(true)
    end,
  })
end

return M
