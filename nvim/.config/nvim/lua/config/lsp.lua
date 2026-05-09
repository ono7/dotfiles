local M = {}

--- Toggle LSP for the current buffer
M.toggle_lsp_for_buffer = function()
  local bufnr = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_clients({ bufnr = bufnr })

  if #clients > 0 then
    -- LSP is active, detach clients
    for _, client in ipairs(clients) do
      vim.lsp.buf_detach_client(bufnr, client.id)
    end
    -- Clean up UI when LSP is manually disabled
    vim.wo[0].winbar = nil
    vim.notify("LSP and Navic disabled", vim.log.levels.INFO)
  else
    -- LSP is inactive, re-attach via filetype
    local ft = vim.bo[bufnr].filetype
    if ft ~= "" then
      vim.bo[bufnr].filetype = ft
      vim.notify("LSP re-enabled", vim.log.levels.INFO)
    end
  end
end

vim.keymap.set("n", "<leader>tl", M.toggle_lsp_for_buffer, { desc = "Toggle LSP for buffer" })

M.setup = function()
  local ok_navic, navic = pcall(require, "nvim-navic")

  --- 1. Global LSP configuration ---
  vim.lsp.config("*", {
    root_markers = { ".git" },
  })

  --- 2. Navic Integration Logic ---
  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("LspNavicAttach", { clear = true }),
    callback = function(args)
      local bufnr = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)

      if ok_navic and client and client.server_capabilities.documentSymbolProvider then
        navic.attach(client, bufnr)

        -- Use a window-local winbar
        vim.wo[0].winbar = " %{%v:lua.require'nvim-navic'.get_location()%}"

        -- DIRECTIONAL FIX: Force a redraw of the winbar on every move
        vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
          buffer = bufnr,
          callback = function()
            -- This forces Neovim to re-evaluate the %{} expression in the winbar
            vim.cmd("redrawstatus")
          end,
        })
      end

      vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
    end,
  })

  --- 3. Manual Completion Trigger (<C-l>) ---
  vim.keymap.set("i", "<C-l>", function()
    local clients = vim.lsp.get_clients({ bufnr = 0 })
    if #clients > 0 then
      return "<C-x><C-o>"
    end
    return "<C-x><C-n>"
  end, { expr = true, replace_keycodes = true, desc = "Smart Completion" })

  --- 4. Enable LSP servers ---
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

  --- 5. Built-in UI Keymaps ---
  -- lspsaga now handles this
  -- vim.keymap.set("n", "K", function()
  --   vim.lsp.buf.hover({ border = "rounded" })
  -- end, { desc = "LSP: Hover documentation" })

  --- 6. Completion & Diagnostic Presentation ---
  vim.o.completeopt = "menuone,fuzzy"

  vim.diagnostic.config({
    update_in_insert = false,
    virtual_text = false,
    severity_sort = true,
    float = { border = "rounded" },
  })

  --- 7. Diagnostic Auto-management ---
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
