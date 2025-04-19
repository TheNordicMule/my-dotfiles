-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- my coolnight colorscheme
config.color_scheme = "catppuccin-mocha"
wezterm.font("Iosevka")

config.warn_about_missing_glyphs = false

config.font_size = 16

config.enable_tab_bar = false

config.max_fps = 144

config.window_decorations = "RESIZE"
config.window_background_opacity = 0.95
config.macos_window_background_blur = 10

-- and finally, return the configuration to wezterm
return config
