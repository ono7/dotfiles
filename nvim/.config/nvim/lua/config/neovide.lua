if not vim.g.neovide then
  return
end

-- 1. Instant OS detection via LuaJIT
local os_name = jit.os -- "OSX", "Windows", "Linux"
local is_mac = os_name == "OSX" or vim.fn.has("macunix") == 1
local is_wsl = os_name == "Linux" and (vim.uv.os_uname().release:lower():find("microsoft") ~= nil)

-- 2. Smooth, Fluid Motion & Gliding Cursor
vim.g.neovide_cursor_animation_length = 0.09 -- Soft, fluid cursor gliding
vim.g.neovide_cursor_trail_size = 0.75 -- Organic trailing tail
vim.g.neovide_cursor_smooth_blink = true -- Gentle pulse/fade when cursor blinks
vim.g.neovide_cursor_blink = true
vim.g.neovide_cursor_blink_interval = 600

vim.g.neovide_cursor_animate_in_insert_mode = true
vim.g.neovide_cursor_animate_command_line = true
vim.g.neovide_cursor_antialiasing = true

-- Fluid Viewport Scrolling
vim.g.neovide_scroll_animation_length = 0.12
vim.g.neovide_scroll_animation_far_lines = 1

-- 3. Visual Effects & High-Performance Floating Windows
vim.g.neovide_floating_blur_amount_x = 0.0 -- Kept at 0 to prevent typing latency during LSP autocomplete
vim.g.neovide_floating_blur_amount_y = 0.0
vim.g.neovide_floating_shadow = false
vim.g.neovide_floating_z_height = 10
vim.g.neovide_light_angle_degrees = 45
vim.g.neovide_light_radius = 5

vim.g.neovide_progress_bar_enabled = true
vim.g.neovide_progress_bar_height = 5.0
vim.g.neovide_progress_bar_animation_speed = 200.0
vim.g.neovide_progress_bar_hide_delay = 0.2

-- Font & Sharpness Setup per OS (Preserving Extended Specs)
if os_name == "Windows" or is_wsl then
  -- Windows / WSL (NVIDIA 1440p)
  vim.o.guifont = "Iosevka Custom:h14:#e-subpixelantialias:#h-full"
elseif is_mac then
  -- macOS (Retina: Sharp grid-snapping without macOS CoreText blur)
  -- vim.o.guifont = "Iosevka Custom:Medium Extended,Bold Extended,Medium Extended Italic:h25:#e-subpixelantialias:#h-full"
  -- The default setting disables subpixel rendering (ideal for Retina)
  vim.g.neovide_pixel_geometry = "Unknown"
  -- vim.o.guifont = "Iosevka Custom:h26:#e-subpixelantialias:#h-full,IosevkaTerm Nerd Font:h26"
  vim.o.guifont = "Iosevka Custom,IosevkaTerm Nerd Font:h26:#e-subpixelantialias:#h-full"
else
  -- Linux Native (NVIDIA 1440p)
  -- vim.o.guifont = "Iosevka Custom:Medium Extended,Bold Extended,Medium Extended Italic:h16:#e-subpixelantialias:#h-full"
  vim.o.guifont = "Iosevka Custom:h19:#e-subpixelantialias:#h-full"
  -- vim.o.guifont = "Iosevka Custom:Medium Extended,Bold Extended,Medium Extended Italic:h16:#e-subpixelantialias:#h-full"
end

-- Font Blending

-- Replicates Alacritty's crisp font rendering
vim.g.neovide_text_gamma = 0.8

-- Flattens the anti-aliasing halo
vim.g.neovide_text_contrast = 0.1

-- linespace = 7 (is about 1.5x, recommended for stigmatism)
vim.opt.linespace = 7

-- 5. Window, UI & Padding
vim.g.neovide_input_macos_option_key_is_meta = "both"
vim.g.neovide_frame_no_title = true
vim.g.neovide_fullscreen = false
vim.g.neovide_idle = true
vim.g.neovide_hide_mouse_when_typing = true
vim.g.neovide_confirm_quit = true
vim.g.neovide_theme = "dark"

vim.g.neovide_padding_top = 0
vim.g.neovide_padding_bottom = 0
vim.g.neovide_padding_left = 10
vim.g.neovide_padding_right = 10

-- Baseline Scale Factor (1.0 leaves macOS native at crisp :h28)
vim.g.neovide_scale_factor = 1.0

-- Dynamic Scale Keymaps (Cmd += / Cmd +- on Mac, Ctrl += / Ctrl +- on Linux/Windows)
local function change_scale_factor(delta)
  local s = vim.g.neovide_scale_factor * delta
  vim.g.neovide_scale_factor = math.max(0.7, math.min(1.5, s))
end

-- local cmd_or_ctrl = is_mac and "<D-" or "<C-"
local cmd_or_ctrl = "<C-"
vim.keymap.set("n", cmd_or_ctrl .. "=>", function()
  change_scale_factor(1.1)
end)
vim.keymap.set("n", cmd_or_ctrl .. "->", function()
  change_scale_factor(1 / 1.1)
end)

-- 6. Highlighting
-- vim.api.nvim_set_hl(0, "Normal", { bg = "#151F2D", fg = "#BEBEBC" })
vim.api.nvim_set_hl(0, "FidgetBorder", { fg = "#1A2230", bg = "#0A0E14" })
-- 7. Deduplicated Keymaps
vim.keymap.set({ "n", "v" }, "<C-S-v>", '"+p')
vim.keymap.set({ "i", "c" }, "<C-S-v>", "<C-r>+")
vim.keymap.set("t", "<C-S-v>", '<C-\\><C-n>"+pi')
if is_mac then
  vim.keymap.set("t", "<D-S-v>", '<C-\\><C-n>"+pi')
end

vim.keymap.set("n", "<C-k>", "<C-w>k")

-- Tab Navigation Loop
for i = 1, 9 do
  vim.keymap.set({ "n", "t", "x" }, "<C-" .. i .. ">", i .. "gt")
end
