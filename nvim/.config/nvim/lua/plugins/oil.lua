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
      extra_scp_args = { "-O" },
      columns = { "icon", add_padding = true },
      keymaps = {
        ["<C-p>"] = false,
        ["<C-h>"] = false,

        -- 1. Make <CR> / Enter open files in existing tab or a new tab
        ["<CR>"] = {
          desc = "Open in existing tab or create a new one",
          callback = function()
            local oil = require("oil")
            local actions = require("oil.actions")
            local entry = oil.get_cursor_entry()
            if not entry then
              return
            end

            -- Let Oil handle directory navigation natively
            if entry.type == "directory" then
              actions.select.callback()
              return
            end

            local current_dir = oil.get_current_dir()
            if not current_dir then
              return
            end

            -- Construct target URI without stripping adapter protocols via fs.normalize
            local is_remote = current_dir:match("^%w+://") ~= nil
            local target_path
            if is_remote then
              target_path = current_dir .. entry.name
            else
              target_path = vim.fs.normalize(current_dir .. entry.name)
            end

            -- Check all tabs and windows for the target file
            for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
              for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tab)) do
                local buf = vim.api.nvim_win_get_buf(win)
                local buf_name = vim.api.nvim_buf_get_name(buf)
                if not is_remote then
                  buf_name = vim.fs.normalize(buf_name)
                end
                if buf_name == target_path then
                  oil.close()
                  vim.api.nvim_set_current_tabpage(tab)
                  vim.api.nvim_set_current_win(win)
                  return
                end
              end
            end

            -- Correct action call to open in a new tab via Oil's adapter
            actions.select.callback({ tab = true })
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
