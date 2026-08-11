if not vim.g.neovide then
  return
end

-- 1. Instant OS detection via LuaJIT (bypasses slow C/Vimscript vim.fn checks)
local os_name = jit.os -- "OSX", "Windows", "Linux"
local is_wsl = os_name == "Linux" and (vim.uv.os_uname().release:lower():find("microsoft") ~= nil)

-- 2. Smooth Typing & Motion
vim.g.neovide_cursor_trail_size = 0.8
vim.g.neovide_cursor_animation_length = 0.03
vim.g.neovide_refresh_rate = 120

vim.g.neovide_input_macos_option_key_is_meta = "both"
vim.g.neovide_cursor_smooth_blink = false
vim.g.neovide_cursor_blink = true
vim.g.neovide_cursor_blink_interval = 500
vim.g.neovide_scroll_animation_far_lines = 0
vim.g.neovide_scroll_animation_length = 0
vim.g.neovide_cursor_animate_in_insert_mode = true
vim.g.neovide_cursor_animate_command_line = true
vim.g.neovide_frame_no_title = true
vim.g.neovide_confirm_quit = true
vim.g.neovide_profiler = false

-- 3. Visual Effects (Kept intact)
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

-- 4. Font & Environment Setup
if os_name == "Windows" or is_wsl then
  vim.opt.guifont = "Iosevka Custom:Medium Extended,Bold Extended,Medium Extended Italic:h14"
elseif os_name == "OSX" then
  vim.o.guifont = "Iosevka Custom:Medium Extended,Bold Extended,Medium Extended Italic:h19"
else
  vim.g.neovide_fullscreen = false
  vim.g.neovide_idle = true
  vim.o.guifont = "Iosevka Custom:h16:m-Semi-Extended"
  vim.g.neovide_font_hinting = "none"
  vim.g.neovide_font_edging = "antialias"
  vim.g.neovide_hide_mouse_when_typing = true
  vim.g.neovide_theme = "dark"
end

vim.g.neovide_text_gamma = 0.8
vim.g.neovide_text_contrast = 0.1
vim.g.neovide_padding_top = 0
vim.g.neovide_padding_bottom = 0
vim.g.neovide_padding_left = 10
vim.g.neovide_padding_right = 10

-- 5. Scale Factor Bindings
vim.g.neovide_scale_factor = 1.0
local function change_scale_factor(delta)
  local s = vim.g.neovide_scale_factor * delta
  vim.g.neovide_scale_factor = math.max(0.8, math.min(1.2, s))
end

vim.keymap.set("n", "<C-=>", function()
  change_scale_factor(1.1)
end)
vim.keymap.set("n", "<C-->", function()
  change_scale_factor(1 / 1.1)
end)

-- 6. Highlighting
vim.api.nvim_set_hl(0, "Normal", { bg = "#151F2D", fg = "#BEBEBC" })
vim.api.nvim_set_hl(0, "FidgetBorder", { fg = "#1A2230", bg = "#0A0E14" })

-- 7. Deduplicated Keymaps
vim.keymap.set({ "n", "v" }, "<C-S-v>", '"+p')
vim.keymap.set({ "i", "c" }, "<C-S-v>", "<C-r>+")
vim.keymap.set("t", "<C-S-v>", '<C-\\><C-n>"+pi')
vim.keymap.set("t", "<D-S-v>", '<C-\\><C-n>"+pi')

vim.keymap.set("n", "<C-k>", "<C-w>k")

-- Tab Navigation Loop
for i = 1, 9 do
  vim.keymap.set({ "n", "t", "x" }, "<C-" .. i .. ">", i .. "gt")
end
