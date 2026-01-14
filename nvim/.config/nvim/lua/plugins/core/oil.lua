return {
  "stevearc/oil.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local set_keys = require("utils.keys")
    local oil_ok, oil_config = pcall(require, "oil")

    if not oil_ok then
      print("Error in pcall oil -> ~/.dotfiles/nvim/lua/plugins/oil.lua")
      return
    end

    -- oil_config.setup {}
    oil_config.setup({
      columns = { "icon", add_padding = true },
      keymaps = {
        ["<C-p>"] = false,
        [set_keys.prefix("v")] = { "actions.select", opts = { vertical = true } },
        [set_keys.prefix("x")] = { "actions.select", opts = { horizontal = true } },
      },
      view_options = {
        show_hidden = true,
      },
      skip_confirm_for_simple_edits = true,

      float = {
        -- Padding around the floating window
        padding = 2,
        max_width = 50,
        max_height = 50,
        border = "rounded",
        win_options = {
          winblend = 0,
        },
        -- preview_split: Split direction: "auto", "left", "right", "above", "below".
        preview_split = "auto",
        -- This is the config that will be passed to nvim_open_win.
        -- Change values here to customize the layout
        override = function(conf)
          return conf
        end,
      },

      -- Selecting a new/moved/renamed file or directory will prompt you to save changes first
      -- (:help prompt_save_on_select_new_entry)
      prompt_save_on_select_new_entry = false,
      cleanup_delay_ms = 2000,
      buflisted = false,
      lsp_file_methods = {
        -- Time to wait for LSP file operations to complete before skipping
        timeout_ms = 3000,
        -- Set to true to autosave buffers that are updated with LSP willRenameFiles
        -- Set to "unmodified" to only save unmodified buffers
        autosave_changes = false,
      },
    })

    -- Open parent directory in current window
    -- vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

    -- Open parent directory in floating window

    -- local binding = vim.loop.os_uname().sysname == "Darwin" and "<M-\\>" or "<C-\\>"
    local binding = "<M-\\>"
    -- vim.keymap.set("n", binding, require("oil").toggle_float({ close = true }))
    vim.keymap.set("n", binding, "<CMD>Oil<CR>")
  end,
}
