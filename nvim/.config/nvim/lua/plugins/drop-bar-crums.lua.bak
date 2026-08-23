-- LSP and document crums in bar
return {
  "Bekaboo/dropbar.nvim",
  dependencies = {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
  },
  lazy = false,
  config = function()
    local dropbar = require("dropbar")
    local dropbar_api = require("dropbar.api")

    dropbar.setup({
      bar = {
        sources = function(buf, _)
          local sources = require("dropbar.sources")
          local utils = require("dropbar.utils")

          -- Filter the path source to only show the file name
          return {
            utils.source.fallback({
              sources.lsp,
              sources.treesitter,
              sources.markdown,
            }),
          }
        end,
      },
      icons = {
        kinds = {
          symbols = {
            Folder = "",
            Directory = "",
            File = "",
          },
        },
      },
    })

    vim.keymap.set("n", "<Leader>;", dropbar_api.pick, { desc = "Pick symbols in winbar" })
    vim.keymap.set("n", "[;", dropbar_api.goto_context_start, { desc = "Go to start of current context" })
    vim.keymap.set("n", "];", dropbar_api.select_next_context, { desc = "Select next context" })
  end,
}
