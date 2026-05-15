return {
  "stevearc/oil.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local oil_ok, oil_config = pcall(require, "oil")

    if not oil_ok then
      print("Error in pcall oil -> ~/.dotfiles/nvim/lua/plugins/oil.lua")
      return
    end

    local detail = false

    oil_config.setup({
      columns = { "icon", add_padding = true },
      keymaps = {
        ["<C-p>"] = false,
        ["<C-t>"] = false,
        ["<C-h>"] = false,
        ["<C-v>"] = { "actions.select", opts = { vertical = true } },
        ["<M-s>"] = { "actions.select", opts = { horizontal = true } },
        ["<C-/>"] = "actions.close",
        ["gd"] = {
          desc = "Toggle file detail view",
          callback = function()
            detail = not detail
            if detail then
              require("oil").set_columns({ "icon", "permissions", "size", "mtime" })
            else
              require("oil").set_columns({ "icon" })
            end
          end,
        },
      },
      view_options = {
        show_hidden = true,
      },
      skip_confirm_for_simple_edits = true,

      float = {
        padding = 2,
        max_width = 50,
        max_height = 50,
        border = "rounded",
        win_options = {
          winblend = 0,
        },
        preview_split = "auto",
        override = function(conf)
          return conf
        end,
      },

      prompt_save_on_select_new_entry = false,
      cleanup_delay_ms = 2000,
      buflisted = false,
      lsp_file_methods = {
        timeout_ms = 3000,
        autosave_changes = false,
      },
    })

    local binding = "<M-\\>"
    vim.keymap.set("n", binding, "<CMD>Oil<CR>")
  end,
}
