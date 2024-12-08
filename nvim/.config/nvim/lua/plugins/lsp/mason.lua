return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "gopls",
          "pyright",
          "ansiblels",
          "html",
          "jsonls",
          "bashls",
          "terraformls",
          "ts_ls",
          "cssls",
          "lua_ls",
          "ruff_lsp",
        },
      })
    end,
  },
}
