local wezterm                                     = require("wezterm")
local scheme                                      = wezterm.get_builtin_color_schemes()['Catppuccin Mocha']
local config                                      = wezterm.config_builder()

local ansi                                        = {
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
scheme.ansi                                       = ansi
scheme.brights                                    = ansi

-- scheme.background = "#161616"
-- scheme.cursor_bg = "#00acc1"
scheme.cursor_bg                                  = "#bac2de"
scheme.cursor_fg                                  = "#000"
local act                                         = wezterm.action
config.default_prog                               = { "/bin/zsh", "--login" }
config.audible_bell                               = "Disabled"
config.use_dead_keys                              = false
config.scrollback_lines                           = 5000
config.scroll_to_bottom_on_input                  = true
config.default_cwd                                = wezterm.homedir
config.disable_default_key_bindings               = true
config.color_schemes                              = {
  -- new or override scheme
  ["Catppuccin Mocha"] = scheme,
}
config.color_scheme                               = 'Catppuccin Mocha'

config.font                                       = wezterm.font('MonoLisaNoLiga Nerd Font', { weight = "Medium" })
config.adjust_window_size_when_changing_font_size = false
config.window_close_confirmation                  = "NeverPrompt"
config.cursor_blink_rate                          = 0
config.default_cursor_style                       = "SteadyBlock"
config.font_size                                  = 22
config.line_height                                = 1.3
config.initial_rows                               = 40
config.initial_cols                               = 100
config.underline_position                         = -8
config.underline_thickness                        = 5
config.window_background_opacity                  = 0.94
config.macos_window_background_blur               = 20
-- window_decorations                         = "RESIZE|MACOS_FORCE_ENABLE_SHADOW|MACOS_NS_VISUAL_EFFECT_MATERIAL_BLUR", -- will blurr eventually
config.window_decorations                         = "RESIZE"
config.hide_tab_bar_if_only_one_tab               = true
config.front_end                                  = "WebGpu"
config.use_fancy_tab_bar                          = false
config.enable_wayland                             = false
-- front_end                                  = "Software"
config.webgpu_power_preference                    = "HighPerformance"
config.window_padding                             = {
  left = 20,
  right = 20,
  top = 5,
  bottom = 5,
}

config.keys                                       = {
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
}

return config
