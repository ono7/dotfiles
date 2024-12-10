return {
  "monkoose/matchparen.nvim",
  enabled = true,
  priority = 20,
  config = function()
    require("matchparen").setup({
      on_startup = true,
      hl_group = "MatchParen",
      augroup_name = "matchparen-nvim",
      debounce_time = 20, -- debounce time in milliseconds for rehighlighting of brackets.
    })
  end,
}
