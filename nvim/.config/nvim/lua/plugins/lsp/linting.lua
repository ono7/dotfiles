return {
  "mfussenegger/nvim-lint",
  event = {
    "BufReadPre",
    "BufNewFile",
  },
  config = function()
    local lint = require("lint")
    lint.linters_by_ft = {
      javascript = {
        "eslint_d",
      },
      python = { "ruff" },
      -- yaml = { "yamllint" },
      zsh = { "zsh" },
      bash = { "bash" },
      ["yaml.ansible"] = {
        "ansible_lint",
      },
    }
    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
      callback = function()
        lint.try_lint()
      end,
      group = vim.api.nvim_create_augroup("linting", { clear = true }),
    })
  end,
}
