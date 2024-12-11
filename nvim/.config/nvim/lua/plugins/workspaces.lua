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
    require("workspaces").setup({
      hooks = {
        open = {
          -- do not run hooks if file already in active workspace
          function()
            if current_file_in_ws() then
              vim.notify("already in in workspace")
              return false
            end
          end,
          -- function()
          --   require("telescope.builtin").find_files()
          -- end,
        },
      },
    })
    -- multiple hooks
    -- require("workspaces").setup({ hooks = { open = { "NvimTreeOpen", "Telescope find_files" } } })
    -- require("workspaces").setup({ hooks = { open = { "Telescope find_files" } } })
  end,
}
