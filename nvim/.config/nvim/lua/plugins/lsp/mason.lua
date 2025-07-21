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
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    requires = {
      "williamboman/mason.nvim",
    },
    config = function()
      require("mason-tool-installer").setup({
        ensure_installed = {
          "golangci-lint",
          "bash-language-server",
          "lua-language-server",
          "vim-language-server",
          "gopls",
          "isort",
          "black",
          "clangd",
          "stylua",
          "shellcheck",
          "sqlfmt",
          "editorconfig-checker",
          "gofumpt",
          "golines",
          "gomodifytags",
          "gotests",
          "goimports",
          "impl",
          "json-to-struct",
          "jq",
          "misspell",
          "revive",
          "shellcheck",
          "shfmt",
          "staticcheck",
          "vint",
          "yamllint",
          "yamlfmt",
          "yamlls",
          -- "hadolint",
          "dockerls",
          -- "diagnosticls",
          -- "sqlls",
          "terraformls",
          -- "delve",
        },
        auto_update = false, -- Disable auto-update for faster startup
        run_on_start = false,
      })
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    requires = {
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
