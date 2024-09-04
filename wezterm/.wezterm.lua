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

-- tab_bar = {
--   background = "#252526",
--   active_tab = {
--     bg_color = "#1e1e1e",
--     fg_color = "#ffffff",
--   },
--   inactive_tab = {
--     bg_color = "#2d2d2d",
--     fg_color = "#808080",
--   },
--   inactive_tab_hover = {
--     bg_color = "#323232",
--     fg_color = "#909090",
--   },
--   new_tab = {
--     bg_color = "#2d2d2d",
--     fg_color = "#808080",
--   },
--   new_tab_hover = {
--     bg_color = "#323232",
--     fg_color = "#909090",
--   },
-- },

-- color overrides
scheme.ansi                                       = ansi
scheme.brights                                    = ansi

-- scheme.background = "#161616"
-- scheme.cursor_bg                                  = "#bac2de"
scheme.background                                 = "#0e1017"
scheme.foreground                                 = "#bfbdb6"
scheme.cursor_bg                                  = "#8a90a8"
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
config.window_background_opacity                  = 0.94
config.macos_window_background_blur               = 20
config.native_macos_fullscreen_mode               = true

-- window_decorations                         = "RESIZE|MACOS_FORCE_ENABLE_SHADOW|MACOS_NS_VISUAL_EFFECT_MATERIAL_BLUR", -- will blurr eventually
config.window_decorations                         = "RESIZE"
config.front_end                                  = "WebGpu"

config.hide_tab_bar_if_only_one_tab               = true
config.tab_max_width                              = 32
config.use_fancy_tab_bar                          = false
config.use_fancy_tab_bar                          = false
config.tab_max_width                              = 32
-- config.colors                                     = {
-- }

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
    mods = "CTRL|SHIFT",
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
