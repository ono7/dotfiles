return {
  "kylechui/nvim-surround",
  event = { "BufReadPre", "BufNewFile" },
  version = "*",
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
