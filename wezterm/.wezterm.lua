local wezterm                                     = require("wezterm")
local config                                      = wezterm.config_builder()

-- Halcyon color scheme
local halcyon                                     = {
  -- foreground = "#bfbdb6",
  foreground = "#a2aabc",
  background = "#1c2433",
  cursor_bg = "#9197b1",
  cursor_fg = "#1d2433",
  cursor_border = "#ffcc66",
  selection_fg = "#1d2433",
  selection_bg = "#ffcc66",
  scrollbar_thumb = "#2f3b54",
  split = "#2f3b54",

  ansi = {
    "#1d2433", -- Black
    "#f38ba8", -- Red (from your config)
    "#ceeac8", -- Green (from your config)
    "#F7CC66", -- Yellow (from your config)
    "#89b4fa", -- Blue (from your config)
    "#b0a0ff", -- Magenta (from your config)
    "#94e2d5", -- Cyan (from your config)
    "#bac2de", -- White (from your config)
  },
  brights = {
    "#6679a4", -- Bright Black
    "#f38ba8", -- Bright Red
    "#ceeac8", -- Bright Green
    "#ffd580", -- Bright Yellow
    "#89b4fa", -- Bright Blue
    "#d4bfff", -- Bright Magenta
    "#94e2d5", -- Bright Cyan
    "#d7dce2", -- Bright White
  },

  -- Tab bar colors (adapted from your existing theme)
  tab_bar = {
    background = "#171c28",
    active_tab = {
      bg_color = "#1d2433",
      fg_color = "#ffcc66",
    },
    inactive_tab = {
      bg_color = "#2f3b54",
      fg_color = "#a2aabc",
    },
    inactive_tab_hover = {
      bg_color = "#3f4c6b",
      fg_color = "#d7dce2",
    },
    new_tab = {
      bg_color = "#171c28",
      fg_color = "#171c28",
    },
    new_tab_hover = {
      bg_color = "#3f4c6b",
      fg_color = "#d7dce2",
    },
  },
}

-- Set up the color scheme
config.color_schemes                              = {
  ["Halcyon"] = halcyon,
}
config.color_scheme                               = "Halcyon"

-- Existing configuration (keeping your settings)
config.default_prog                               = { "/bin/zsh", "--login" }
config.audible_bell                               = "Disabled"
config.use_dead_keys                              = false
config.scrollback_lines                           = 5000
config.scroll_to_bottom_on_input                  = true
config.default_cwd                                = wezterm.homedir
config.disable_default_key_bindings               = true

config.font                                       = wezterm.font('MonoLisaNoLiga Nerd Font', { weight = "Medium" })
config.font_size                                  = 23
config.adjust_window_size_when_changing_font_size = false
config.line_height                                = 1.3

config.default_cursor_style                       = "SteadyBlock"
config.window_close_confirmation                  = "NeverPrompt"
config.cursor_blink_rate                          = 0
config.initial_rows                               = 40
config.initial_cols                               = 100
config.underline_position                         = -8
config.underline_thickness                        = 5
config.window_background_opacity                  = 0.97
config.macos_window_background_blur               = 20
config.native_macos_fullscreen_mode               = true

config.window_decorations                         = "RESIZE"
config.front_end                                  = "WebGpu"

config.hide_tab_bar_if_only_one_tab               = true
config.tab_max_width                              = 32
config.use_fancy_tab_bar                          = false

config.enable_wayland                             = false
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
  { key = '0', mods = 'CTRL', action = wezterm.action.ResetFontSize },
  { key = '=', mods = 'CTRL', action = wezterm.action.IncreaseFontSize },
  { key = '-', mods = 'CTRL', action = wezterm.action.DecreaseFontSize },
  {
    key = "w",
    mods = "SHIFT|CTRL",
    action = wezterm.action.CloseCurrentPane({ confirm = false }),
  },
  {
    -- turn off cmd+m to hide window from the os
    key = "q",
    mods = "CTRL",
    action = wezterm.action.DisableDefaultAssignment,
  },
  {
    key = "v",
    mods = "CTRL|SHIFT",
    action = wezterm.action.PasteFrom("Clipboard"),
  },
  {
    -- delete word
    key = "Backspace",
    mods = "CTRL",
    action = wezterm.action.SendString("\x17"),
  },
  {
    key = "Backspace",
    mods = "ALT",
    action = wezterm.action.SendString("\x17"),
  },
  { key = 't', mods = 'CTRL|SHIFT', action = wezterm.action.SpawnTab("DefaultDomain") },
  { key = 'h', mods = 'CTRL|SHIFT', action = wezterm.action.ActivateTabRelative(1) },
  { key = 'l', mods = 'CTRL|SHIFT', action = wezterm.action.ActivateTabRelative(-1) },
  -- Vertical pipe (|) -> horizontal split
  {
    key = '\\',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.SplitHorizontal {
      domain = 'CurrentPaneDomain'
    },
  },
  -- Underscore (_) -> vertical split
  {
    key = '-',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.SplitVertical {
      domain = 'CurrentPaneDomain'
    },
  },
  -- Rename current tab
  {
    key = 'N',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.PromptInputLine {
      description = 'Enter new name for tab',
      action = wezterm.action_callback(
        function(window, _, line)
          if line then
            window:active_tab():set_title(line)
          end
        end
      ),
    },
  },
  -- {
  --   key = "h",
  --   mods = "CTRL",
  --   action = wezterm.action.ActivatePaneDirection('Left')
  -- },
  --
  -- {
  --   key = "j",
  --   mods = "CTRL",
  --   action = wezterm.action.ActivatePaneDirection('Down')
  -- },
  --
  -- {
  --   key = "k",
  --   mods = "CTRL",
  --   action = wezterm.action.ActivatePaneDirection('Up')
  -- },
  --
  -- {
  --   key = "l",
  --   mods = "CTRL",
  --   action = wezterm.action.ActivatePaneDirection('Right')
  -- },
  {
    key = 'z',
    mods = 'CTRL',
    action = wezterm.action.TogglePaneZoomState,
  },
}

return config
