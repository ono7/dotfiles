-- TODO: need to figure out how to start in home dir
if vim.g.neovide then
  -- see ~/.config/neovide/config.toml
  -- vim.g.neovide_window_blurred = true
  -- vim.g.neovide_scale_factor = 1.4
  vim.g.neovide_refresh_rate = 120
  vim.g.neovide_cursor_animation_length = 0.07
  vim.g.neovide_cursor_vfx_mode = ""
  vim.g.neovide_input_macos_option_key_is_meta = "both"
  vim.g.neovide_cursor_smooth_blink = false
  vim.g.neovide_cursor_trail_size = 0.01
  vim.g.neovide_cursor_smooth_blink = false
  vim.g.neovide_scroll_animation_far_lines = 0
  vim.g.neovide_scroll_animation_length = 0.00
  vim.g.neovide_cursor_animate_in_insert_mode = true
  vim.g.neovide_cursor_animate_command_line = false
  vim.g.neovide_frame_no_title = true -- remove title bar

  vim.opt.guifont = "Iosevka Custom:h26:#h-none"

  vim.opt.linespace = 4

  --- change font size with
  local change_scale_factor = function(delta)
    vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
  end
  vim.keymap.set("n", "<D-=>", function()
    change_scale_factor(1.25)
  end)
  vim.keymap.set("n", "<D-->", function()
    change_scale_factor(1 / 1.25)
  end)
end