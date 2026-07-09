-- ────────────────────────────────────────────────────────────────────────────
-- Setup
-- ────────────────────────────────────────────────────────────────────────────
local wezterm = require("wezterm")
local act = wezterm.action
local config = wezterm.config_builder()

-- ────────────────────────────────────────────────────────────────────────────
-- Appearance
-- ────────────────────────────────────────────────────────────────────────────
-- Terminal (pane) colors come from wezterm's builtin scheme (set by Nix).
config.color_scheme = scheme_name
local scheme = wezterm.color.get_builtin_schemes()[scheme_name]

-- Status-bar palette pulled from the active scheme (no hardcoded hex) so it
-- tracks color_scheme. accent = ANSI cyan (nord8 #88c0d0) to match the nvim
-- lualine mode indicator and the tmux active window; the scheme's ansi[5] is the
-- duller nord9 blue we deliberately avoid.
local bar = {
	bg = scheme.background, -- nord0 #2e3440
	fg = scheme.brights[8], -- nord6 #eceff4 (bright white, = tmux FG)
	accent = scheme.ansi[7], -- nord8 #88c0d0 (ANSI cyan)
	gray = scheme.brights[1], -- nord3 #4c566a (ANSI bright-black)
}

-- Slim single-face family, NOT the ~423MB/162-face "Iosevka" super-TTC (that
-- collection made every resize reshape hammer a half-gig mmap -> massive lag).
config.font = wezterm.font("Iosevka Nerd Font")
config.warn_about_missing_glyphs = false
config.font_size = 16

-- ────────────────────────────────────────────────────────────────────────────
-- Keybindings (tmux-style)
-- ────────────────────────────────────────────────────────────────────────────
-- Sessionizer: fuzzy-pick a project dir and jump to a per-directory workspace
-- (native-workspace port of bins/tmux-sessionizer).

-- Resolve fd (fuzzy-finder) from common per-platform install locations.
-- The wezterm GUI on macOS launches with a minimal PATH that often omits
-- Homebrew, nix, or Cargo, so we probe known absolute paths up front.
-- As a last resort we ask a login shell where it lives.
local function resolve_fd()
	-- 1) Check known absolute paths (fast, no subprocess).
	for _, path in ipairs({
		"/opt/homebrew/bin/fd",
		"/usr/local/bin/fd",
		wezterm.home_dir .. "/.cargo/bin/fd",
		"/run/current-system/sw/bin/fd",
		wezterm.home_dir .. "/.nix-profile/bin/fd",
	}) do
		local f = io.open(path, "r")
		if f then
			f:close()
			return path
		end
	end
	-- 2) Fallback: ask a login shell (slower but catches env-managed tools).
	--    The "-l" flag ensures the shell sources profile files so $PATH is
	--    fully populated, mirroring what you'd get in a terminal.
	local ok, stdout, _ = wezterm.run_child_process({
		"zsh",
		"-l",
		"-c",
		"command -v fd",
	})
	if ok then
		local path = stdout:gsub("[\n\r]", "")
		if path ~= "" then
			return path
		end
	end
	return "fd"
end

local fd = resolve_fd()

-- basename with dots turned into underscores, mirroring `basename | tr . _`.
local function workspace_name(path)
	return path:gsub("/+$", ""):gsub(".*/", ""):gsub("%.", "_")
end

-- Persistent per-workspace root (mirrors tmux's session start dir): new
-- splits/tabs open here, not the current pane's cwd. GLOBAL survives reloads.
local function set_workspace_root(name, path)
	local roots = wezterm.GLOBAL.workspace_roots or {}
	roots[name] = path
	wezterm.GLOBAL.workspace_roots = roots
end

local function workspace_root(window)
	local roots = wezterm.GLOBAL.workspace_roots or {}
	return roots[window:active_workspace()] or wezterm.home_dir
end

local function split_at_root(direction)
	return wezterm.action_callback(function(window, pane)
		local args = { domain = "CurrentPaneDomain", cwd = workspace_root(window) }
		if direction == "h" then
			window:perform_action(act.SplitHorizontal(args), pane)
		else
			window:perform_action(act.SplitVertical(args), pane)
		end
	end)
end

local function spawn_tab_at_root()
	return wezterm.action_callback(function(window, pane)
		window:perform_action(
			act.SpawnCommandInNewTab({ domain = "CurrentPaneDomain", cwd = workspace_root(window) }),
			pane
		)
	end)
end

local function sessionizer()
	return wezterm.action_callback(function(window, pane)
		local home = wezterm.home_dir
		-- fd . --search-path ~ --search-path ~/work --exact-depth 1 --type d
		local ok, stdout, stderr = wezterm.run_child_process({
			fd,
			".",
			"--search-path",
			home,
			"--search-path",
			home .. "/work",
			"--exact-depth",
			"1",
			"--type",
			"d",
		})
		if not ok then
			wezterm.log_error("sessionizer: fd failed: " .. (stderr or ""))
			window:toast_notification("Sessionizer", "fd not found — check PATH or install fd")
			return
		end

		local choices = {}
		for line in stdout:gmatch("[^\n]+") do
			table.insert(choices, { label = line })
		end
		if #choices == 0 then
			return
		end

		window:perform_action(
			act.InputSelector({
				title = "Sessionizer",
				fuzzy = true,
				choices = choices,
				action = wezterm.action_callback(function(inner_window, inner_pane, _id, label)
					if not label then
						return
					end
					local name = workspace_name(label)
					set_workspace_root(name, label)
					inner_window:perform_action(
						-- Switches to the workspace, creating it (scoped to cwd) if absent.
						act.SwitchToWorkspace({ name = name, spawn = { cwd = label } }),
						inner_pane
					)
				end),
			}),
			pane
		)
	end)
end

config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }

config.keys = {
	{ key = "f", mods = "CTRL", action = sessionizer() },

	{ key = "c", mods = "LEADER", action = spawn_tab_at_root() },
	{ key = "n", mods = "LEADER", action = act.ActivateTabRelative(1) },
	{ key = "p", mods = "LEADER", action = act.ActivateTabRelative(-1) },
	{
		key = ",",
		mods = "LEADER",
		action = act.PromptInputLine({
			description = "Enter new name for tab",
			action = wezterm.action_callback(function(window, _pane, line)
				if line then
					window:active_tab():set_title(line)
				end
			end),
		}),
	},

	{ key = "v", mods = "LEADER", action = split_at_root("h") },
	{ key = "s", mods = "LEADER", action = split_at_root("v") },

	{ key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
	{ key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },
	{ key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
	{ key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },
	{
		key = "[",
		mods = "LEADER",
		action = wezterm.action.ActivateCopyMode,
	},
}

-- ActivateTab is 0-indexed, so LEADER + 1 selects the first tab.
for i = 1, 9 do
	table.insert(config.keys, {
		key = tostring(i),
		mods = "LEADER",
		action = act.ActivateTab(i - 1),
	})
end

-- tmux-style search in copy mode: `/` and `?` open the search prompt and `n`/`N`
-- cycle matches. key_tables replaces the whole table, so extend the defaults.
local default_key_tables = wezterm.gui.default_key_tables()
local copy_mode = default_key_tables.copy_mode
for _, bind in ipairs({
	{ key = "/", mods = "NONE", action = act.Search({ CaseSensitiveString = "" }) },
	{ key = "?", mods = "NONE", action = act.Search({ CaseSensitiveString = "" }) },
	{ key = "?", mods = "SHIFT", action = act.Search({ CaseSensitiveString = "" }) },
	{ key = "n", mods = "NONE", action = act.CopyMode("NextMatch") },
	{ key = "N", mods = "NONE", action = act.CopyMode("PriorMatch") },
	{ key = "N", mods = "SHIFT", action = act.CopyMode("PriorMatch") },
}) do
	table.insert(copy_mode, bind)
end

-- Default Enter (internally "mapped:\r") is PriorMatch, which keeps the pattern
-- editor open so `n` types into the pattern. AcceptPattern exits editing back to
-- copy mode, where n/N navigate matches.
local search_mode = default_key_tables.search_mode
for _, bind in ipairs(search_mode) do
	if (bind.key == "mapped:\r" or bind.key == "Enter") and bind.mods == "NONE" then
		bind.action = act.CopyMode("AcceptPattern")
	end
end

config.key_tables = { copy_mode = copy_mode, search_mode = search_mode }

-- ────────────────────────────────────────────────────────────────────────────
-- Tab bar
-- ────────────────────────────────────────────────────────────────────────────
config.enable_tab_bar = true

-- The fancy tab bar draws its own chrome from window_frame, not colors.tab_bar,
-- so both are pulled from the bar palette to keep the whole bar on-palette.
config.window_frame = {
	active_titlebar_bg = bar.bg,
	inactive_titlebar_bg = bar.bg,
	-- Fancy tab bar height tracks this font size (defaults to 10pt).
	font_size = 14,
}

config.colors = {
	tab_bar = {
		inactive_tab_edge = bar.bg,
		active_tab = {
			bg_color = bar.accent,
			fg_color = bar.bg,
		},
		inactive_tab = {
			bg_color = bar.bg,
			fg_color = bar.fg,
		},
		inactive_tab_hover = {
			bg_color = bar.gray,
			fg_color = bar.fg,
		},
		new_tab = {
			bg_color = bar.bg,
			fg_color = bar.fg,
		},
		new_tab_hover = {
			bg_color = bar.accent,
			fg_color = bar.bg,
		},
	},
}

wezterm.on("update-status", function(window, _pane)
	window:set_left_status(wezterm.format({
		{ Foreground = { Color = bar.accent } },
		{ Text = "  " .. window:active_workspace() .. "  " },
	}))
	window:set_right_status("")
end)

-- ────────────────────────────────────────────────────────────────────────────
-- Window
-- ────────────────────────────────────────────────────────────────────────────
config.max_fps = 144
config.window_decorations = "RESIZE"
config.window_background_opacity = 0.95
config.macos_window_background_blur = 10

return config
