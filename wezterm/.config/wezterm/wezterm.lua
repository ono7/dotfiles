local wezterm = require("wezterm")
local config = wezterm.config_builder()

local act = wezterm.action

local function tab_title(tab_info)
	local title = tab_info.tab_title
	-- if the tab title is explicitly set, take that
	if title and #title > 0 then
		return title
	end
	-- Otherwise, use the title from the active pane
	-- in that tab
	return tab_info.active_pane.title
end

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local title = tab_title(tab)
	-- allow upto 35 chars in title
	title = wezterm.truncate_left(title, 35 - 2)
	return {
		{ Text = " " .. title .. " " },
	}
end)

local my_background = "#1f2937"
-- local my_background = "#000000"
local my_background_lighter = "#24364b"
local my_background_darker = "#141f2b"
local my_foreground = "#c5c8d3"

-- Halcyon color scheme
local halcyon = {
	-- foreground = "#bfbdb6",
	foreground = my_foreground,
	background = my_background,
	-- foreground = "#a7b1c8",
	-- background = "#1c2433",
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
		"#acafb8", -- Bright White
	},

	-- Tab bar colors (adapted from your existing theme)
	tab_bar = {
		background = my_background_darker,
		active_tab = {
			bg_color = my_background,
			fg_color = "#d4bfff",
		},
		inactive_tab = {
			bg_color = my_background_darker,
			fg_color = "#6c7584",
		},
		inactive_tab_hover = {
			bg_color = "#3f4c6b",
			fg_color = "#d7dce2",
		},
		new_tab = {
			bg_color = my_background_darker,
			fg_color = my_background_darker,
		},
		new_tab_hover = {
			bg_color = "#3f4c6b",
			fg_color = "#d7dce2",
		},
	},
}

-- Set up the color scheme
config.color_schemes = {
	["Halcyon"] = halcyon,
}
config.color_scheme = "Halcyon"
config.default_prog = { "/bin/zsh", "--login" }
config.audible_bell = "Disabled"
config.use_dead_keys = false
config.max_fps = 120
config.prefer_egl = true
config.enable_kitty_keyboard = true
config.animation_fps = 120
config.scrollback_lines = 5000
config.scroll_to_bottom_on_input = true
config.default_cwd = wezterm.homedir
config.disable_default_key_bindings = true
config.font = wezterm.font("MonoLisaNoLiga Nerd Font", { weight = "Regular" })
config.font_size = 22
config.adjust_window_size_when_changing_font_size = false
config.line_height = 1.3
config.default_cursor_style = "SteadyBlock"
config.window_close_confirmation = "NeverPrompt"
config.cursor_blink_rate = 0
config.initial_rows = 40
config.initial_cols = 100
config.underline_position = -8
config.underline_thickness = 5
config.window_background_opacity = 0.98
config.macos_window_background_blur = 20
config.native_macos_fullscreen_mode = true
config.window_decorations = "RESIZE"
config.front_end = "WebGpu"
config.hide_tab_bar_if_only_one_tab = true
config.tab_max_width = 32
config.use_fancy_tab_bar = false
config.enable_wayland = false
config.webgpu_power_preference = "HighPerformance"
config.window_padding = {
	left = 20,
	right = 20,
	top = 5,
	bottom = 5,
}

config.key_tables = {
	copy_mode = wezterm.gui.default_key_tables().copy_mode,
}

config.keys = {
	-- use xxd -psd to get hex char sequences
	{ key = "e", mods = "CTRL|SHIFT", action = wezterm.action.ActivateCopyMode },
	{ key = "s", mods = "CTRL|SHIFT", action = wezterm.action.Search("CurrentSelectionOrEmptyString") },
	{ key = "0", mods = "CMD", action = act.ResetFontSize },
	{ key = "=", mods = "CMD", action = act.IncreaseFontSize },
	{ key = "-", mods = "CMD", action = act.DecreaseFontSize },
	{
		key = "w",
		mods = "SHIFT|CTRL",
		action = act.CloseCurrentPane({ confirm = false }),
	},
	{
		key = "q",
		mods = "CMD",
		action = act.DisableDefaultAssignment,
	},
	{
		key = "w",
		mods = "CMD",
		action = act.DisableDefaultAssignment,
	},
	{
		key = "s",
		mods = "CMD",
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
	{ key = "t", mods = "CTRL|SHIFT", action = act.SpawnTab("DefaultDomain") },
	{ key = "l", mods = "CTRL|SHIFT", action = act.ActivateTabRelative(1) },
	{ key = "h", mods = "CTRL|SHIFT", action = act.ActivateTabRelative(-1) },
	-- Vertical pipe (|) -> horizontal split
	{
		key = "\\",
		mods = "CTRL|SHIFT",
		action = act.SplitHorizontal({
			domain = "CurrentPaneDomain",
		}),
	},
	-- Underscore (_) -> vertical split
	{
		key = "-",
		mods = "CTRL|SHIFT",
		action = act.SplitVertical({
			domain = "CurrentPaneDomain",
		}),
	},
	-- Rename current tab
	{
		key = "N",
		mods = "CTRL|SHIFT",
		action = act.PromptInputLine({
			description = "Enter new name for tab",
			action = wezterm.action_callback(function(window, pane, line)
				if line then
					window:active_tab():set_title(line)
				end
			end),
		}),
	},
	{
		key = "l",
		mods = "CTRL",
		action = act.Multiple({ act.SendKey({ key = "l", mods = "CTRL" }), act.ActivatePaneDirection("Right") }),
	},
	{
		key = "k",
		mods = "CTRL",
		action = act.Multiple({ act.SendKey({ key = "k", mods = "CTRL" }), act.ActivatePaneDirection("Up") }),
	},
	{
		key = "j",
		mods = "CTRL",
		action = act.Multiple({ act.SendKey({ key = "j", mods = "CTRL" }), act.ActivatePaneDirection("Down") }),
	},
	{
		key = "h",
		mods = "CTRL",
		action = act.Multiple({ act.SendKey({ key = "h", mods = "CTRL" }), act.ActivatePaneDirection("Left") }),
	},
}

return config
