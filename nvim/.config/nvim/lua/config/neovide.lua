local opt = { noremap = true }

if vim.g.neovide then
  -- **** anything shell related for neovide should go into ~/.zprofile ****

  -- the most important settings for smooth typing
  vim.g.neovide_cursor_animation_length = 0.03
  vim.g.neovide_cursor_trail_size = 0.04
  vim.g.neovide_input_ime = false
  vim.g.neovide_refresh_rate = 120
  -- vim.g.neovide_cursor_vfx_mode = ""
  vim.g.neovide_input_macos_option_key_is_meta = "both"
  vim.g.neovide_cursor_smooth_blink = true
  vim.g.neovide_cursor_blink = false
  vim.g.neovide_cursor_blink_interval = 500
  vim.g.neovide_scroll_animation_far_lines = 0
  vim.g.neovide_scroll_animation_length = 0
  vim.g.neovide_cursor_animate_in_insert_mode = true
  vim.g.neovide_cursor_animate_command_line = true
  vim.g.neovide_frame_no_title = true
  -- wider text

  -- vim.g.neovide_window_blurred = true
  -- vim.g.neovide_opacity = 0.90
  vim.g.neovide_confirm_quit = true

  -- show refresh rate
  vim.g.neovide_profiler = false

  -- vim.opt.guifont = "SF Mono:h23:#h-none:Medium"
  local uname = vim.loop.os_uname()
  local is_wsl = uname.sysname == "Linux" and uname.release:lower():match("microsoft")

  -- if vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 or is_wsl then
  --   vim.opt.guifont = "Iosevka Custom:Medium Extended,Bold Extended,Medium Extended Italic:h14"
  -- else
  --   vim.opt.guifont = "Iosevka Custom:Medium Extended,Bold Extended,Medium Extended Italic:h24"
  -- end
  --
  vim.g.neovide_text_gamma = 0.8
  vim.g.neovide_text_contrast = 0.1

  vim.g.neovide_floating_blur_amount_x = 2.0
  vim.g.neovide_floating_blur_amount_y = 2.0

  vim.g.neovide_floating_shadow = true
  vim.g.neovide_floating_z_height = 10
  vim.g.neovide_light_angle_degrees = 45
  vim.g.neovide_light_radius = 5

  vim.g.neovide_progress_bar_enabled = true
  vim.g.neovide_progress_bar_height = 5.0
  vim.g.neovide_progress_bar_animation_speed = 200.0
  vim.g.neovide_progress_bar_hide_delay = 0.2

  vim.g.neovide_scale_factor = 1.0
  --- change font size with
  local function change_scale(delta)
    local s = vim.g.neovide_scale_factor * delta
    vim.g.neovide_scale_factor = math.max(0.8, math.min(1.2, s))
  end

  vim.keymap.set("n", "<C-=>", function()
    change_scale_factor(1.01) -- Changed from 1.25 to 1.1 for smaller increase
  end)

  vim.keymap.set("n", "<C-->", function()
    change_scale_factor(1 / 1.01) -- Changed from 1.25 to 1.1 for smaller decrease
  end)

  -- unbind quit from neovide
  -- vim.keymap.set({ "n", "i", "v", "t" }, "<D-q>", "")
  vim.g.neovide_padding_top = 0
  vim.g.neovide_padding_bottom = 0
  vim.g.neovide_padding_left = 10
  vim.g.neovide_padding_right = 10
  -- Terminal mode paste mapping
  vim.keymap.set("t", "<C-S-v>", '<C-\\><C-n>"+pi', { desc = "Paste in terminal mode" })

  vim.keymap.set("t", "<D-S-v>", '<C-\\><C-n>"+pi', { desc = "Paste in terminal mode" })

  vim.api.nvim_set_hl(0, "Normal", { bg = "#151F2D", fg = "#BEBEBC" })
  vim.api.nvim_set_hl(0, "FidgetBorder", { fg = "#1A2230", bg = "#0A0E14" })

  -- Map Cmd+g to Ctrl+g in multiple modes
  -- vim.keymap.set({ "i", "n", "v", "x" }, "<D-g>", "<C-g>")
  --
  -- vim.keymap.set({ "c", "n", "i" }, "<D-p>", "<C-p>")
  -- vim.keymap.set({ "c", "n", "i" }, "<D-n>", "<C-n>")

  -- Paste with Ctrl+Shift+V in all modes
  vim.keymap.set("n", "<C-S-v>", '"+p', { noremap = true })
  vim.keymap.set("i", "<C-S-v>", "<C-r>+", { noremap = true })
  vim.keymap.set("c", "<C-S-v>", "<C-r>+", { noremap = true })
  vim.keymap.set("v", "<C-S-v>", '"+p', { noremap = true })
  vim.keymap.set("t", "<C-S-v>", '<C-\\><C-n>"+pi', { noremap = true })
  vim.keymap.set({ "n", "t" }, "<C-k>", "<C-w>k", { noremap = true })

  -- Tab navigation (works in terminal and Neovide)
  vim.keymap.set({ "n", "t", "x" }, "<C-1>", "1gt", opt)
  vim.keymap.set({ "n", "t", "x" }, "<C-2>", "2gt", opt)
  vim.keymap.set({ "n", "t", "x" }, "<C-3>", "3gt", opt)
  vim.keymap.set({ "n", "t", "x" }, "<C-4>", "4gt", opt)
  vim.keymap.set({ "n", "t", "x" }, "<C-5>", "5gt", opt)
  vim.keymap.set({ "n", "t", "x" }, "<C-6>", "6gt", opt)
  vim.keymap.set({ "n", "t", "x" }, "<C-7>", "7gt", opt)
  vim.keymap.set({ "n", "t", "x" }, "<C-8>", "8gt", opt)
  vim.keymap.set({ "n", "t", "x" }, "<C-9>", "9gt", opt)
end
