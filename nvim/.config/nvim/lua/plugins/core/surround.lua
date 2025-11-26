return {
  "kylechui/nvim-surround",
  version = "^3.0.0", -- Use for stability; omit to use `main` branch for the latest features
  event = "VeryLazy",
  config = function()
    require("nvim-surround").setup({
      keymaps = {
        insert = "<C-g>s",
        insert_line = "<C-g>S",
        -- normal = "s",
        normal_cur = "ys",
        normal_line = "yS",
        normal_cur_line = "ySS",
        -- visual = "GS",
        visual_line = "gS",
        delete = "ds",
        change = "cs",
      },
    })
  end,
}
