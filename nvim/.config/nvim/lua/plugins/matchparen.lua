return {
  "monkoose/matchparen.nvim",
  config = function()
    require("matchparen").setup({
      on_startup = true,
      hl_group = "MatchParen",
      augroup_name = "matchparen",
      debounce_time = 20, -- debounce time in milliseconds for rehighlighting of brackets.
    })
  end,
}
