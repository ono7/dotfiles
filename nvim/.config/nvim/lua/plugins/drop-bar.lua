return {
  "Bekaboo/dropbar.nvim",
  dependencies = {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
  },
  -- Ensure it loads immediately if you want it visible on all buffers
  lazy = false,
  config = function()
    local dropbar = require("dropbar")
    local dropbar_api = require("dropbar.api")

    dropbar.setup({
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

    -- Define keymaps after setup
    vim.keymap.set("n", "<Leader>;", dropbar_api.pick, { desc = "Pick symbols in winbar" })
    vim.keymap.set("n", "[;", dropbar_api.goto_context_start, { desc = "Go to start of current context" })
    vim.keymap.set("n", "];", dropbar_api.select_next_context, { desc = "Select next context" })
  end,
}
