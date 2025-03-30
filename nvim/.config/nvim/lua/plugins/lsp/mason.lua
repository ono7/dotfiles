return {
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    lazy = true,
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    requires = {
      -- "neovim/nvim-lspconfig",
      "williamboman/mason.nvim",
    },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "gopls",
          "pyright",
          "eslint",
          "ansiblels",
          "jsonls",
          "bashls",
          "ts_ls",
          "terraformls",
          "html",
          "cssls",
          "lua_ls",
          "ruff",
        },
      })
    end,
  },
}
