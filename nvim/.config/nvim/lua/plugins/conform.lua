return {
  "stevearc/conform.nvim",
  opts = {},
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local conform = require("conform")
    conform.setup({
      formatters_by_ft = {
        lua = { "stylua" },
        -- Conform will run multiple formatters sequentially
        python = { "black" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        css = { "prettier" },
        scss = { "prettier" },
        html = { "prettier" },
        json = { "prettier" },
        -- yaml = { "prettier" },
        markdown = { "prettier" },
        -- goimports drop in replacement for gofmt
        go = { "goimports", "goimports-reviser" },
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
      end,
    })
    -- vim.keymap.set({ "n", "v" }, "<leader>mp", function()
    --   conform.format({
    --     lsp_fallback = true,
    --     async = false,
    --     timeout = 1000,
    --   })
    -- end)
  end,
}
