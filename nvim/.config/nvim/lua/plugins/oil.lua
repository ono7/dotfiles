local oil_ok, oil_config = pcall(require, "oil")

if not oil_ok then
  print("Error in pcall oil -> ~/.dotfiles/nvim/lua/plugins/oil.lua")
  return
end

-- oil_config.setup {}
oil_config.setup {
  columns = { "icon" },
  keymaps = {
    -- ["<C-h>"] = false,
    ["<c-v>"] = "actions.select_split",
  },
  view_options = {
    show_hidden = true,
  },
  skip_confirm_for_simple_edits = true,

  -- Selecting a new/moved/renamed file or directory will prompt you to save changes first
  -- (:help prompt_save_on_select_new_entry)
  prompt_save_on_select_new_entry = false,
  cleanup_delay_ms = 4000,
  lsp_file_methods = {
    -- Time to wait for LSP file operations to complete before skipping
    timeout_ms = 3000,
    -- Set to true to autosave buffers that are updated with LSP willRenameFiles
    -- Set to "unmodified" to only save unmodified buffers
    autosave_changes = false,
  },
}

-- Open parent directory in current window
-- vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

-- Open parent directory in floating window
vim.keymap.set("n", "-", require("oil").toggle_float)
