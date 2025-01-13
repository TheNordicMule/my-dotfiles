-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- my coolnight colorscheme
config.color_scheme = "nord"
wezterm.font("Iosevka")

config.font_size = 16

config.enable_tab_bar = false

config.max_fps = 144

config.window_decorations = "RESIZE"
config.window_background_opacity = 0.95
config.macos_window_background_blur = 10
config.keys = {
	{
		key = "q",
		mods = "CTRL|SHIFT",
		action = wezterm.action.SendString("\x1b[81;6u"),
	},
}

-- and finally, return the configuration to wezterm
return config
