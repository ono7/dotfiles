require("conform").setup({
  formatters_by_ft = {
    lua = {
      "luafmt",
      lsp_format = "fallback",
      inherit = false,
      command = "shfmt",
      args = { "-i", "2", "-filename", "$FILENAME" }
    },
    -- Conform will run multiple formatters sequentially
    python = { "black" },
    javascript = { "prettier" },
    typescript = { "prettier" },
    css = { "prettier" },
    scss = { "prettier" },
    html = { "prettier" },
    json = { "prettier" },
    -- yaml = { "prettier" },
    -- markdown = { "prettier" },
    -- goimports drop in replacement for gofmt
    go = { "goimports", "goimports-reviser" },
    markdown = { "prettier" },
    graphql = { "prettier", stop_after_first = true },
  },
  formatters = {
    shfmt = {
      prepend_args = { "-i", "2" },
    },
  },
  format_on_save = {
    -- lsp_format = "fallback",
    timeout_ms = 700,
  },
  format_after_save = function(bufnr)
    -- disable with a global or buffer-local variable
    if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
      return
    end
    return { timeout_ms = 5000, lsp_format = "fallback" }
  end
})
