return {
  "SmiteshP/nvim-navic",
  lazy = true,
  -- This ensures navic is loaded as soon as any LSP attaches
  event = "LspAttach",
  config = function()
    require("nvim-navic").setup({
      highlight = true,
      separator = "  ",
      depth_limit = 5,
      lazy_update_context = true,
      -- click_support = false, -- Matches your mouse="n" setup
    })
  end,
}
