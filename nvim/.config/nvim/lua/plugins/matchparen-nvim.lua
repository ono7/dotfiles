return {
  "monkoose/matchparen.nvim",
  config = function()
    require("matchparen").setup({
      -- Set to `false` to disable at matchpren at startup
      -- Enable matchparen manually with `:MatchParenEnable`
      enabled = true,
      -- Highlight group of the matched brackets
      -- Change it to any other or adjust colors of "MathParen" highlight group
      -- in your colorscheme to your liking
      hl_group = "MatchParen",
      -- Debounce time in milliseconds for rehighlighting brackets
      -- Set to 0 to disable debouncing
      -- debounce_time = 60,
      debounce_time = 0,
    })
  end,
}
