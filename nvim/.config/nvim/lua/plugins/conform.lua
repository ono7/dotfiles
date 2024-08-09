require("conform").setup({
  formatters_by_ft = {
    lua = { "luafmt", lsp_format = "fallback" },
    -- Conform will run multiple formatters sequentially
    python = { "black" },
    javascript = { "prettier" },
    typescript = { "prettier" },
    css = { "prettier" },
    scss = { "prettier" },
    html = { "prettier" },
    json = { "prettier" },
    yaml = { "prettier" },
    markdown = { "prettier" },
    -- go install -v github.com/incu6us/goimports-reviser/v3@latest
    -- go install golang.org/x/tools/cmd/goimports@latest
    -- goimports also formats just like gofmt
    go = { "goimports", "goimports-reviser" },
    -- markdown = { "mdformat" }, -- might need to try this one
    graphql = { "prettier", stop_after_first = true },
  },
  format_on_save = {
    -- lsp_format = "fallback",
    timeout_ms = 500,
  },
  format_after_save = function(bufnr)
    -- disable with a global or buffer-local variable
    if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
      return
    end
    return { timeout_ms = 5000, lsp_format = "fallback" }
  end
})
