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
        ["<C-h>"] = false,

        -- 1. Make <CR> / Enter open files in a new tab by default
        ["<CR>"] = {
          desc = "Open file in new tab and close oil in previous window",
          callback = function()
            local oil = require("oil")
            local entry = oil.get_cursor_entry()
            if not entry then
              return
            end

            -- If it's a directory, let oil enter the directory as normal
            if entry.type == "directory" then
              oil.select()
              return
            end

            -- Get current oil directory and full file path
            local current_dir = oil.get_current_dir()
            if not current_dir then
              return
            end
            local file_path = current_dir .. entry.name

            -- Close Oil / restore previous buffer in current window before opening tab
            oil.close()

            -- Open the target file in a brand new tab
            vim.cmd("tabedit " .. vim.fn.fnameescape(file_path))
          end,
        },

        -- 2. Explicit Tab binding (<C-t>)
        ["<C-t>"] = { "actions.select", opts = { tab = true }, desc = "Open in new tab" },

        -- 3. Splits
        ["<C-v>"] = { "actions.select", opts = { vertical = true }, desc = "Open in vertical split" },
        ["<M-s>"] = { "actions.select", opts = { horizontal = true }, desc = "Open in horizontal split" },

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
    vim.keymap.set("n", "<c-\\>", "<CMD>Oil<CR>")
  end,
}
