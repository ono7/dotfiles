return {
  "ono7/workspaces.nvim",
  config = function()
    local is_dir_in_parent = function(dir, parent)
      if parent == nil then
        return false
      end
      local ws_str_find, _ = string.find(dir, parent, 1, true)
      if ws_str_find == 1 then
        return true
      else
        return false
      end
    end

    local current_file_in_ws = function()
      local workspaces = require("workspaces")
      local ws_path = require("workspaces.util").path
      local current_ws = workspaces.path()
      local current_file_dir = ws_path.parent(vim.fn.expand("%:p", true))
      return is_dir_in_parent(current_file_dir, current_ws)
    end

    --- keymaps ---

    vim.keymap.set("n", "<leader>wa", function()
      vim.cmd([[WorkspacesAdd]])
    end, { noremap = true, silent = true })
    vim.keymap.set("n", "<leader>wd", function()
      vim.cmd([[WorkspacesRemove]])
    end, { noremap = true, silent = true })

    vim.keymap.set("n", "<leader>we", function()
      -- local path = vim.fn.stdpath("data") .. "/workspaces"
      local path = os.getenv("HOME") .. "/.workspaces"
      vim.cmd.edit(path)
    end, { noremap = true, silent = true })

    require("workspaces").setup({

      -- path = vim.fn.stdpath("data") .. "/workspaces",
      path = os.getenv("HOME") .. "/.workspaces",

      cd_type = "global",

      -- sort the list of workspaces by name after loading from the workspaces path.
      sort = true,

      -- sort by recent use rather than by name. requires sort to be true
      mru_sort = true,

      -- option to automatically activate workspace when opening neovim in a workspace directory
      auto_open = true,

      -- option to automatically activate workspace when changing directory not via this plugin
      -- set to "autochdir" to enable auto_dir when using :e and vim.opt.autochdir
      -- valid options are false, true, and "autochdir"
      auto_dir = true,

      -- enable info-level notifications after adding or removing a workspace
      notify_info = true,
      hooks = {
        open = {
          -- do not run hooks if file already in active workspace
          function()
            if current_file_in_ws() then
              vim.notify("already in in workspace")
              return false
            end
          end,
          function()
            local set_keys = require("utils.keys")
            local actions = require("telescope.actions")

            local default_maps = {
              i = {
                [set_keys.prefix("f")] = actions.to_fuzzy_refine,
                [set_keys.prefix("p")] = actions.move_selection_previous,
                [set_keys.prefix("n")] = actions.move_selection_next,
                [set_keys.prefix("q")] = actions.smart_add_to_qflist + actions.open_qflist,
                [set_keys.prefix("x")] = actions.select_horizontal,
                [set_keys.prefix("v")] = actions.select_vertical,
                ["<M-x>"] = actions.select_horizontal,
                ["<M-v>"] = actions.select_vertical,

                ["<M-p>"] = actions.move_selection_previous,
                ["<M-n>"] = actions.move_selection_next,
              },
              n = { ["q"] = actions.close },
            }
            require("telescope.builtin").find_files({
              hidden = true,
              no_ignore = false,
              -- sorting by modified is single threaded, but we dont expect many files
              defaults = {
                mappings = default_maps,
              },
              find_command = {
                "rg",
                "--files",
                "--sortr=modified",
                "--glob",
                "!**/__pycache__/*",
                "--glob",
                "!venv/*",
                "--glob",
                "!.git/*",
                "--glob",
                "!node_modules/*",
                "--glob",
                "!.collections/*",
              },
            })
          end,
        },
      },
    })
    -- multiple hooks
    -- require("workspaces").setup({ hooks = { open = { "NvimTreeOpen", "Telescope find_files" } } })
    -- require("workspaces").setup({ hooks = { open = { "Telescope find_files" } } })
  end,
}
