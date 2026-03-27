return {
  "nvim-treesitter/nvim-treesitter",
  branch = "master", -- this is frozen, but is compatible with neovim 0.11.x
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter.configs").setup({
      ensure_installed = {},
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = {
        enable = false,
      },
      incremental_selection = { enable = false },
      textobjects = { enable = false },
    })
  end,
}
