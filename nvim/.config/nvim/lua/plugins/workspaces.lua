return {
  "natecraddock/workspaces.nvim",
  config = function()
    -- multiple hooks
    -- require("workspaces").setup({ hooks = { open = { "NvimTreeOpen", "Telescope find_files" } } })
    require("workspaces").setup({ hooks = { open = { "Telescope find_files" } } })
  end,
}
