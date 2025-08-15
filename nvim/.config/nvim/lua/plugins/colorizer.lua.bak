return {
  "NvChad/nvim-colorizer.lua",
  event = "BufReadPre",
  config = function()
    require("colorizer").setup({
      filetypes = { lua = { names = false, mode = "background" }, "css", "html", "scss" },
      user_default_options = {
        css = true,
        css_fn = true,
        names = true,
        mode = "background",
        tailwind = true,
        sass = { enable = false, parsers = { "css" } },
        virtualtext = "■",
        always_update = true,
      },
    })
  end,
}
