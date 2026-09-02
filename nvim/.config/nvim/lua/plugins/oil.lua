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
          desc = "Open in existing tab or create a new one",
          callback = function()
            local oil = require("oil")
            local entry = oil.get_cursor_entry()
            if not entry then
              return
            end

            if entry.type == "directory" then
              oil.select()
              return
            end

            local current_dir = oil.get_current_dir()
            if not current_dir then
              return
            end
            local target_path = vim.fs.normalize(current_dir .. entry.name)

            -- Check all tabs and windows for the target file
            for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
              for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tab)) do
                local buf = vim.api.nvim_win_get_buf(win)
                local buf_name = vim.fs.normalize(vim.api.nvim_buf_get_name(buf))
                if buf_name == target_path then
                  -- Switch to that tab and window, close oil first
                  oil.close()
                  vim.api.nvim_set_current_tabpage(tab)
                  vim.api.nvim_set_current_win(win)
                  return
                end
              end
            end

            -- If not open in any tab, close oil and open in a new tab
            oil.close()
            vim.cmd("tabedit " .. vim.fn.fnameescape(target_path))
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
