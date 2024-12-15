return {
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
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
          "eslint",
          "ansiblels",
          "jsonls",
          "bashls",
          "terraformls",
          "ts_ls",
          "html",
          "cssls",
          "lua_ls",
          "ruff_lsp",
        },
      })
    end,
  },
}
