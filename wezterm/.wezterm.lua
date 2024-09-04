local wezterm = require("wezterm")
local scheme = wezterm.get_builtin_color_schemes()['Catppuccin Mocha']

local ansi = {
  "#45475a",
  "#f38ba8",
  "#ceeac8",
  -- "#bce6b2",
  -- "#f9e2af",
  "#F7CC66",
  "#89b4fa",
  -- "#cba6f7",
  -- "#9581ff",
  "#b0a0ff",
  "#94e2d5",
  "#bac2de",
}

-- color overrides
scheme.ansi = ansi
scheme.brights = ansi

-- scheme.background = "#161616"
-- scheme.cursor_bg = "#00acc1"
scheme.cursor_bg = "#bac2de"
scheme.cursor_fg = "#000"
local act = wezterm.action

-- local colors, metadata = wezterm.color.load_scheme("~/.config/wezterm/theme_ayu.toml")
return {
  default_prog                               = { "/bin/zsh", "--login" },
  audible_bell                               = "Disabled",
  use_dead_keys                              = false,
  scrollback_lines                           = 5000,
  scroll_to_bottom_on_input                  = true,
  default_cwd                                = wezterm.homedir,
  disable_default_key_bindings               = true,
  keys                                       = {
    -- use xxd -psd to get hex char sequences
    -- CTRL-SHIFT-l activates the debug overlay
    { key = '0', mods = 'CTRL', action = act.ResetFontSize },
    { key = '=', mods = 'CTRL', action = act.IncreaseFontSize },
    { key = '-', mods = 'CTRL', action = act.DecreaseFontSize },
    {
      key = "w",
      mods = "SHIFT|CTRL",
      action = act.CloseCurrentPane({ confirm = false }),
    },
    {
      -- turn off cmd+m to hide window from the os
      key = "q",
      mods = "CTRL",
      action = act.DisableDefaultAssignment,
    },
    {
      key = "v",
      mods = "CTRL",
      action = act.PasteFrom("Clipboard"),
    },
    {
      -- delete word
      key = "Backspace",
      mods = "CTRL",
      action = act.SendString("\x17"),
    },
    {
      key = "Backspace",
      mods = "ALT",
      action = act.SendString("\x17"),
    },
    { key = 't', mods = 'CTRL|SHIFT', action = act.SpawnTab("DefaultDomain") },
    { key = 'h', mods = 'CTRL|SHIFT', action = act.ActivateTabRelative(1) },
    { key = 'l', mods = 'CTRL|SHIFT', action = act.ActivateTabRelative(-1) },
  },
  color_schemes                              = {
    -- new or override scheme
    ["Catppuccin Mocha"] = scheme,
  },
  color_scheme                               = 'Catppuccin Mocha',
  font                                       = wezterm.font('MonoLisaNoLiga Nerd Font', { weight = "Medium" }),
  adjust_window_size_when_changing_font_size = false,
  window_close_confirmation                  = "NeverPrompt",
  cursor_blink_rate                          = 0,
  default_cursor_style                       = "SteadyBlock",
  font_size                                  = 22,
  line_height                                = 1.3,
  initial_rows                               = 40,
  initial_cols                               = 100,
  underline_position                         = -8,
  underline_thickness                        = 5,
  window_background_opacity                  = 0.94,
  macos_window_background_blur               = 20,

  -- window_decorations                         = "RESIZE|MACOS_FORCE_ENABLE_SHADOW|MACOS_NS_VISUAL_EFFECT_MATERIAL_BLUR", -- will blurr eventually
  window_decorations                         = "RESIZE",
  hide_tab_bar_if_only_one_tab               = true,
  front_end                                  = "WebGpu",
  use_fancy_tab_bar                          = false,
  enable_wayland                             = false,
  -- front_end                                  = "Software",
  webgpu_power_preference                    = "HighPerformance",
  window_padding                             = {
    left = 20,
    right = 20,
    top = 5,
    bottom = 5,
  },
}
