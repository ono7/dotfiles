return {
  "olexsmir/gopher.nvim",
  ft = "go",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  -- Explicitly register commands so they can trigger lazy loading or autocomplete
  cmd = {
    "GoInstallDeps",
    "GoUpdateDeps",
    "GoTagAdd",
    "GoTagRm",
    "GoIfErr",
    "GoTestAdd",
    "GoTestsAll",
    "GoMod",
  },
  opts = {},
  build = function()
    -- Load the plugin and run setup before invoking the installation command
    vim.cmd.packadd("gopher.nvim")
    require("gopher").setup()
    vim.cmd("GoInstallDeps")
  end,
}
