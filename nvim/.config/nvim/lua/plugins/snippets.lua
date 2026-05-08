return {

  "dcampos/nvim-snippy",
  opts = {},
  config = function()
    require("snippy").setup({
      snippet_dirs = "~/.config/nvim/snippets",
      mappings = {
        is = {
          ["<Tab>"] = "expand_or_advance",
          -- ["<S-Tab>"] = "previous",
        },
        x = {
          ["<leader>d"] = "cut_text",
        },
      },
    })
  end,
}
