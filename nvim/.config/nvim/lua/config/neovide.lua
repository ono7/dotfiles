local opt = { noremap = true }

if vim.g.neovide then
  -- TODO: need to figure out how to start in home dir
  -- see ~/.config/neovide/config.toml for the rest

  -- **** anything shell related for neovide should go into ~/.zprofile ****

  vim.api.nvim_set_hl(0, "Cursor", { bg = "#E288F7" })
  vim.opt.guicursor = "n-c-v-i:block-Cursor"
  -- the most important settings for smooth typing
  vim.g.neovide_cursor_animation_length = 0.07
  vim.g.neovide_cursor_trail_size = 0.01

  vim.g.neovide_refresh_rate = 120
  vim.g.neovide_cursor_vfx_mode = ""
  vim.g.neovide_input_macos_option_key_is_meta = "both"
  vim.g.neovide_cursor_smooth_blink = false
  vim.g.neovide_cursor_smooth_blink = false
  vim.g.neovide_scroll_animation_far_lines = 0
  vim.g.neovide_scroll_animation_length = 0.00
  vim.g.neovide_cursor_animate_in_insert_mode = true
  vim.g.neovide_cursor_animate_command_line = false
  vim.g.neovide_frame_no_title = true

  -- vim.g.neovide_window_blurred = true
  -- vim.g.neovide_opacity = 0.90
  vim.g.neovide_confirm_quit = true
  -- vim.opt.guifont = "SF Mono:h23:#h-none:Medium"

  vim.opt.linespace = 10

  --- change font size with
  local change_scale_factor = function(delta)
    vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
  end

  vim.keymap.set("n", "<D-=>", function()
    change_scale_factor(1.01) -- Changed from 1.25 to 1.1 for smaller increase
  end)

  vim.keymap.set("n", "<D-->", function()
    change_scale_factor(1 / 1.01) -- Changed from 1.25 to 1.1 for smaller decrease
  end)

  -- unbind quit from neovide
  -- vim.keymap.set({ "n", "i", "v", "t" }, "<D-q>", "")

  -- Terminal mode paste mapping
  vim.keymap.set("t", "<C-S-v>", '<C-\\><C-n>"+pi', { desc = "Paste in terminal mode" })

  vim.keymap.set("t", "<D-S-v>", '<C-\\><C-n>"+pi', { desc = "Paste in terminal mode" })

  -- vim.api.nvim_set_hl(0, "Normal", { bg = "#1a1f32", fg = "#a8b5d1" })
  vim.api.nvim_set_hl(0, "Normal", { bg = "#171f2c", fg = "#c5bfb8" })

  -- Map Cmd+g to Ctrl+g in multiple modes

  vim.keymap.set({ "i", "n", "v", "x" }, "<D-g>", "<C-g>")

  vim.keymap.set({ "c", "n", "i" }, "<D-p>", "<C-p>")
  vim.keymap.set({ "c", "n", "i" }, "<D-n>", "<C-n>")

  -- Regular increment/decrement
  vim.keymap.set("n", "<D-x>", "<c-x>", opt)

  -- Visual mode increment/decrement
  vim.keymap.set("x", "<D-a>", "g<C-a>", opt)
  vim.keymap.set("x", "<D-x>", "g<C-x>", opt)
  vim.keymap.set("n", "<D-a>", "<C-a>")

  vim.keymap.set("n", "<D-V>", '"+p', { noremap = true })    -- Normal mode
  vim.keymap.set("i", "<D-V>", "<C-R>+", { noremap = true }) -- Insert mode
  vim.keymap.set("c", "<D-V>", "<C-R>+", { noremap = true }) -- Insert mode
  vim.keymap.set("v", "<D-V>", '"+p', { noremap = true })    -- Visual mode
  vim.keymap.set("t", "<D-V>", '<C-\\><C-N>"+pi', { noremap = true })
end
