return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter.configs").setup({
      auto_install = true,     -- on-demand parser installation
      ensure_installed = {},   -- empty = no manual list

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
