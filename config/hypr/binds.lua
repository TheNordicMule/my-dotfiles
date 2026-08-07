-- AeroSpace-inspired Alt workspace, focus, move, and utility bindings.
-- Loaded from hyprland.lua as extraConfig; `mod`, `terminal`, and `menu`
-- are Lua locals defined by the Home Manager module's settings.
-- See https://wiki.hypr.land/Configuring/Basics/Binds/

-- Terminal / launcher
hl.bind("ALT + Return", hl.dsp.exec_cmd(terminal))
hl.bind("ALT + Space", hl.dsp.exec_cmd(menu))
hl.bind("ALT + Q", hl.dsp.window.close())
hl.bind("CTRL + ALT + Q", hl.dsp.exec_cmd("noctalia msg session lock-and-suspend"))

-- Fullscreen (maximized), float, pseudo
hl.bind(mod .. " + F", hl.dsp.window.fullscreen({ mode = "maximized" }))
hl.bind(mod .. " + T", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mod .. " + P", hl.dsp.window.pseudo())

-- Reload config
hl.bind("ALT + R", hl.dsp.exec_cmd("hyprctl reload"))

-- Dwindle: toggle split
hl.bind(mod .. " + S", hl.dsp.layout("togglesplit"))

-- Move focus (vim-style)
hl.bind(mod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mod .. " + J", hl.dsp.focus({ direction = "down" }))
hl.bind(mod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mod .. " + L", hl.dsp.focus({ direction = "right" }))

-- Move window
hl.bind(mod .. " + SHIFT + H", hl.dsp.window.move({ direction = "left" }))
hl.bind(mod .. " + SHIFT + J", hl.dsp.window.move({ direction = "down" }))
hl.bind(mod .. " + SHIFT + K", hl.dsp.window.move({ direction = "up" }))
hl.bind(mod .. " + SHIFT + L", hl.dsp.window.move({ direction = "right" }))

-- Resize active window
hl.bind(mod .. " + Minus", hl.dsp.window.resize({ x = -50, y = 0, relative = true }))
hl.bind(mod .. " + Equal", hl.dsp.window.resize({ x = 50, y = 0, relative = true }))

-- Previous workspace
hl.bind(mod .. " + Tab", hl.dsp.focus({ workspace = "previous" }))

-- Workspaces 1-10
hl.bind(mod .. " + 1", hl.dsp.focus({ workspace = 1 }))
hl.bind(mod .. " + 2", hl.dsp.focus({ workspace = 2 }))
hl.bind(mod .. " + 3", hl.dsp.focus({ workspace = 3 }))
hl.bind(mod .. " + 4", hl.dsp.focus({ workspace = 4 }))
hl.bind(mod .. " + 5", hl.dsp.focus({ workspace = 5 }))
hl.bind(mod .. " + 6", hl.dsp.focus({ workspace = 6 }))
hl.bind(mod .. " + 7", hl.dsp.focus({ workspace = 7 }))
hl.bind(mod .. " + 8", hl.dsp.focus({ workspace = 8 }))
hl.bind(mod .. " + 9", hl.dsp.focus({ workspace = 9 }))
hl.bind(mod .. " + 0", hl.dsp.focus({ workspace = 10 }))

-- Move window to workspace
hl.bind(mod .. " + SHIFT + 1", hl.dsp.window.move({ workspace = 1 }))
hl.bind(mod .. " + SHIFT + 2", hl.dsp.window.move({ workspace = 2 }))
hl.bind(mod .. " + SHIFT + 3", hl.dsp.window.move({ workspace = 3 }))
hl.bind(mod .. " + SHIFT + 4", hl.dsp.window.move({ workspace = 4 }))
hl.bind(mod .. " + SHIFT + 5", hl.dsp.window.move({ workspace = 5 }))
hl.bind(mod .. " + SHIFT + 6", hl.dsp.window.move({ workspace = 6 }))
hl.bind(mod .. " + SHIFT + 7", hl.dsp.window.move({ workspace = 7 }))
hl.bind(mod .. " + SHIFT + 8", hl.dsp.window.move({ workspace = 8 }))
hl.bind(mod .. " + SHIFT + 9", hl.dsp.window.move({ workspace = 9 }))
hl.bind(mod .. " + SHIFT + 0", hl.dsp.window.move({ workspace = 10 }))

-- Screenshots (Noctalia IPC)
hl.bind("Print", hl.dsp.exec_cmd("noctalia msg screenshot-region"))
hl.bind("SHIFT + Print", hl.dsp.exec_cmd("noctalia msg screenshot-fullscreen all"))
hl.bind("CTRL + Print", hl.dsp.exec_cmd("noctalia msg screenshot-fullscreen pick"))

-- Clipboard / media
hl.bind("ALT + V", hl.dsp.exec_cmd("noctalia msg panel-toggle clipboard"))
hl.bind("ALT + M", hl.dsp.exec_cmd("playerctl play-pause"))

-- Media keys (volume/brightness go through Noctalia IPC; media playback has no
-- Noctalia IPC command, so it stays on playerctl)
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("noctalia msg volume-up"), { repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("noctalia msg volume-down"), { repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("noctalia msg volume-mute"), { locked = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("noctalia msg brightness-up"), { repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("noctalia msg brightness-down"), { repeating = true })

-- Window rules
hl.window_rule({ match = { class = ".*" }, suppress_event = "maximize" })
hl.window_rule({ match = { title = "^(Picture-in-Picture)$" }, float = true })
