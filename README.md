# my-dotfiles

A curated set of dotfiles for **macOS** (nix-darwin) and **NixOS** (Hyprland desktop), with **Nord** / **Catppuccin** / **Gruvbox** theme switching across the entire stack — terminal, editor, window manager, status bar, and prompt.

## Features

- **Unified theme system** — toggle between Nord, Catppuccin, and Gruvbox across all apps with a single command
- **macOS desktop** — AeroSpace (tiling WM), SketchyBar (menu bar), WezTerm, and nix-darwin
- **NixOS desktop** — Hyprland (Lua config, AeroSpace-inspired bindings), Noctalia v5 (Wayland shell/bar: launcher, clipboard, notifications, control center, lock/idle, wallpaper rotation), BlueZ, fan monitoring, driverless printing, Steam, and `nh os switch` (see `nixos/README.md`)
- **Newer user-facing apps** — Firefox (declarative policies via Home Manager), Vesktop (Discord), Steam (NixOS), Obsidian (notes)
- **Minimal Neovim IDE** — lazy.nvim with LSP, DAP, autocompletion, test runner, git integration, and AI assistance (sidekick.nvim); plugins are served from the Nix store with lazy.nvim as fallback
- **WezTerm multiplexer** — WezTerm handles multiplexing natively (tabs, splits, workspaces, copy mode) with tmux-style keybindings (`C-a` leader, `h/j/k/l` navigation)
- **spotify-player** — terminal Spotify client (requires Spotify Premium), theme-aware via Nix
- **nix-darwin / NixOS + home-manager** — declarative system *and* user config (packages, fonts, system settings, dotfiles, bins)

## Quick Start

```bash
# 1. Install dependencies
./clone_dependencies.sh

# 2. (one-time, only if migrating from Stow) remove old Stow symlinks so
#    home-manager can take over the same target paths:
stow -D git wezterm zsh && stow -D --target="$HOME/.config" config

# 3. Build nix-darwin system (this also activates home-manager, which deploys
#    all dotfiles and bins/ to ~/ and ~/.config/):
nh darwin switch . -H Mac-that-vim

# 4. Restart your shell (or `source ~/.zshrc`) so theme-switch and aliases are on PATH
```

After the first build, `switch` (in `bins/`) reformats, rebuilds via `nh`, and commits in one step.

For the NixOS host (`nixos-desktop`, Hyprland) the same home-manager config is
built with `nh os switch path:. -H nixos-desktop` — see
`nixos/README.md` for installation and why the `path:` flake ref is required.

## Theme Switching

```bash
theme-switch nord        # apply Nord theme everywhere
theme-switch catppuccin  # apply Catppuccin Mocha everywhere
theme-switch gruvbox     # apply Gruvbox everywhere
```

This seds the `theme` value in `modules/theme.nix` to the new theme, reformats
with `nixfmt`, and rebuilds the active OS:

- **macOS:** `nh darwin switch . -H Mac-that-vim`, then reloads SketchyBar.
- **NixOS:** `nh os switch path:. -H nixos-desktop` (`path:`
  so the gitignored `nixos/hardware-configuration.nix` stays visible).

`nh` self-elevates internally, so no `sudo` is needed.

The rebuild propagates the theme to starship, wezterm, bat, nvim, sketchybar
(macOS), opencode's TUI theme, spotify-player, and zsh's autosuggestion color —
and, on NixOS, to Hyprland's borders (rendered from the theme palette in
`modules/theme.nix`) and to the active wallpaper collection Noctalia
reads from `~/Pictures` (`config/noctalia/config.toml`, rendered in
`modules/features/noctalia.nix`).
WezTerm picks up its config change via file watching. `theme-switch` reloads
SketchyBar automatically (macOS) and, on NixOS, runs `hyprctl reload` so the new
border colors apply; Noctalia hot-reloads its own config, so no bar/wallpaper
restart is needed. These reloads are best-effort so a failed reload never blocks
a successful rebuild. A restart of Neovim, OpenCode, and spotify-player is
required; the Zsh autosuggestion color applies in newly started Zsh sessions.

## Structure

```
my-dotfiles/
├── flake.nix                 # Thin root: inputs + flake-parts + import-tree (auto-imports modules/)
├── flake.lock
├── modules/                  # Auto-imported — every .nix file is a flake-parts module
│   ├── flake-parts.nix       #   Registers the `flake.modules` option
│   ├── helpers.nix           #   Declares `flake.darwinConfigurations` + `dotfiles.theme` option
│   ├── theme.nix             #   Sets the theme value (single sed-editable line) + runtime theme file
│   ├── hosts/                #   One file per host — assembles a configuration from the features
│   │   ├── mac-that-vim.nix  #     Assembles darwinConfigurations."Mac-that-vim" from features
│   │   └── nixos-desktop.nix #     Assembles nixosConfigurations."nixos-desktop" from features
│   ├── users/
│   │   └── mingshiwang.nix   #   home-manager base + selects which feature modules to import
│   └── features/             #   One file per capability (dendritic: organize by feature, not host)
│       ├── base.nix          #     darwin: primary user, nix daemon, fonts, shell; nixos: common baseline (bluetooth, docker, network, pipewire, shell, nix, fonts)
│       ├── system.nix        #     darwin: keyboard, dock, touch-id, menu bar
│       ├── packages.nix      #     darwin/nixos: environment.systemPackages
│       ├── homebrew.nix      #     darwin: taps / brews / casks
│       ├── nvidia.nix        #     nixos: NVIDIA GPU (open modules, modesetting, stable driver)
│       ├── hyprland.nix      #     nixos: Hyprland/UWSM/portals/greetd + wallpapers; HM: Hyprland user session
│       ├── noctalia.nix      #     nixos: Noctalia v5 shell/bar (programs.noctalia + recommended services); HM: Noctalia user config
│       ├── fans.nix          #     nixos: fan monitoring (it87 driver, lm-sensors)
│       ├── printing.nix      #     nixos: driverless printing (CUPS, Avahi mDNS discovery)
│       ├── git.nix           #     HM: git config
│       ├── zsh.nix           #     HM: zsh (theme-aware autosuggest color)
│       ├── fzf.nix           #     HM: fzf
│       ├── bat.nix           #     HM: bat (theme-aware)
│       ├── ripgrep.nix       #     HM: ripgrep
│       ├── tealdeer.nix      #     HM: tealdeer
│       ├── starship.nix      #     HM: starship (theme-aware palettes)
│       ├── wezterm.nix       #     HM: wezterm (theme-aware scheme injection)
│       ├── nvim.nix          #     HM: neovim (out-of-store symlink)
│       ├── sketchybar.nix    #     HM: sketchybar (read-only nix-store)
│       ├── spotify-player.nix#     HM: spotify-player (programs.spotify-player, theme-aware)
│       ├── opencode.nix      #     HM: opencode (programs.opencode, theme-aware)
│       ├── firefox.nix       #     HM: firefox (declarative policies; macOS cask duplicated — see TROUBLESHOOTING.md)
│       ├── steam.nix         #     nixos: programs.steam (32-bit libs, hardware accel, gamepads)
│       ├── vesktop.nix       #     HM: vesktop (Discord, home.packages)
│       ├── localsend.nix     #     HM/nixos: LocalSend — LAN file sharing (home.packages; opens port 53317 on NixOS)
│       ├── swayimg.nix       #     HM: swayimg — Wayland image viewer (home.packages + xdg.mimeApps; Linux-only)
│       ├── thunderbird.nix   #     HM: thunderbird — mailto/email default handler via xdg.mimeApps (Linux-only)
│       ├── static-configs.nix#     HM: aerospace (read-only nix-store)
│       └── bins.nix          #     HM: switch, theme-switch on $PATH
├── bins/                     # Executable helpers (deployed to ~/bin by home-manager)
│   ├── switch                #   Reformat, rebuild active OS via nh (darwin/os switch), commit
│   ├── theme-switch          #   Theme toggle (Nord / Catppuccin / Gruvbox)
├── config/                   # Deployed to ~/.config/ by home-manager
│   ├── aerospace/            #   macOS tiling window manager (static-configs)
│   ├── hypr/                 #   NixOS Hyprland Lua bindings (binds.lua)
│   ├── noctalia/             #   NixOS shell/bar — config.toml (@WALLPAPER_DIR@ rendered by noctalia.nix)
│   ├── nvim/                 #   Neovim (lazy.nvim) — out-of-store symlink (reads ~/.config/theme at startup)
│   ├── opencode/             #   OpenCode AI — config and personal skills via programs.opencode
│   └── sketchybar/           #   macOS menu bar — read-only nix-store config (reads ~/.config/theme at runtime)
├── wezterm/                  # WezTerm Lua config (Nix injects scheme_name based on `theme`)
├── nixos/                    # NixOS host: README + hardware-configuration.nix.example (real file is gitignored)
├── TROUBLESHOOTING.md        # Record: local overrides, known issues, update checklist
└── README.md
```

The config uses the **dendritic pattern**: every `.nix` file under `modules/` is a top-level flake-parts module, auto-discovered by [import-tree](https://github.com/vic/import-tree) — no manual imports list to maintain. Feature files set `flake.modules.darwin.<name>`, `flake.modules.nixos.<name>` and/or `flake.modules.homeManager.<name>`; the files under `modules/hosts/` assemble a `darwinConfiguration`/`nixosConfiguration` from them. The `theme` value lives in one place (`modules/theme.nix`, declared as the `dotfiles.theme` option in `helpers.nix`) and is read by every themed feature module.

## Key Bindings

### Hyprland (NixOS)

`mod` is `SUPER`; `terminal` is `wezterm` and `menu` is Noctalia's launcher
(`noctalia msg panel-toggle launcher`). Bindings are loaded from
`config/hypr/binds.lua` (see also the AeroSpace section below — the layout is
intentionally AeroSpace-inspired). Shell actions — launcher, clipboard,
screenshots, volume, brightness, lock-and-suspend — go through `noctalia msg`
(Noctalia IPC); media playback has no Noctalia IPC command, so it stays on
`playerctl`.

| Binding                      | Action                                       |
| ---------------------------- | -------------------------------------------- |
| `Alt-Return`                 | Terminal (`wezterm`)                         |
| `Alt-Space`                  | Noctalia launcher panel (`panel-toggle launcher`) |
| `Alt-Q`                      | Close window                                 |
| `Alt-Ctrl-Q`                 | Lock and suspend (`noctalia msg session lock-and-suspend`) |
| `Alt-R`                      | Reload Hyprland (`hyprctl reload`)           |
| `mod-f` / `mod-t` / `mod-p`  | Fullscreen (maximized) / toggle float / pseudo-tiling |
| `mod-s`                      | Toggle split (dwindle)                       |
| `mod-h/j/k/l`                | Focus window left/down/up/right              |
| `mod-shift-h/j/k/l`          | Move window left/down/up/right               |
| `mod--` / `mod-=`            | Resize active window narrower / wider        |
| `mod-tab`                    | Previous workspace                           |
| `mod-1…0` / `mod-shift-1…0`  | Switch to / move window to workspace 1–10    |
| `Print`                      | Region screenshot (`noctalia msg screenshot-region`) |
| `Shift-Print`                | Screenshot all outputs (`screenshot-fullscreen all`) |
| `Ctrl-Print`                 | Screenshot monitor picker (`screenshot-fullscreen pick`) |
| `Alt-v`                      | Clipboard history (`noctalia msg panel-toggle clipboard`) |
| `Alt-m`                      | Play/pause (`playerctl`)                     |
| `XF86Audio*` / `XF86MonBrightness*` | Volume (`noctalia msg volume-*`) / brightness (`noctalia msg brightness-*`) |

### AeroSpace (Window Manager)

| Binding                 | Action                          |
| ----------------------- | ------------------------------- |
| `alt-1` through `alt-0` | Switch workspace                |
| `alt-h/j/k/l`           | Focus window left/down/up/right |
| `alt-shift-h/j/k/l`     | Move window left/down/up/right  |
| `alt-t`                 | Toggle float/tile               |
| `alt-f`                 | Fullscreen                      |
| `alt-shift-space`       | Cycle layout                    |

### WezTerm

| Binding           | Action                                 |
| ----------------- | -------------------------------------- |
| `C-a c`           | New tab                                |
| `C-a n` / `C-a p` | Next / previous tab                    |
| `C-a 1-9`         | Jump to tab N                          |
| `C-a ,`           | Rename tab                             |
| `C-a v` / `C-a s` | Vertical / horizontal split            |
| `C-a h/j/k/l`     | Navigate panes                         |
| `C-f`             | Sessionizer (fuzzy workspace selector) |
| `C-a [`           | Copy mode (vi-style)                   |

### Neovim

| Binding                   | Action                      |
| ------------------------- | --------------------------- |
| `<leader>y` / `<leader>p` | System clipboard yank/paste |
| `<leader>d`               | Black-hole delete           |
| `]e` / `[e`               | Next/previous diagnostic    |
| `]w` / `[w`               | Next/previous warning       |
| `Q`                       | Repeat last macro           |

## Package Management

| Layer    | Tool            | Manages                                            |
| -------- | --------------- | -------------------------------------------------- |
| System   | nix-darwin      | Packages, fonts, system settings, Homebrew casks   |
| User     | Homebrew        | Casks not in nixpkgs (AeroSpace, SketchyBar, etc.) |
| Dotfiles | home-manager    | Symlinks configs + bins to `~/` and `~/.config/`   |
| Plugins  | Nix + lazy.nvim | Neovim plugins — core plugins from `vimPlugins` via a Nix linkFarm (`modules/features/nvim.nix`), anything else installed by lazy.nvim |

On NixOS, system packages come from `environment.systemPackages`
(`modules/features/packages.nix`) and Steam via `programs.steam`
(`modules/features/steam.nix`); user-scoped apps (Firefox, Vesktop, …) are
installed by home-manager into the user profile.

> home-manager deploys static configs as read-only nix-store symlinks; the
> runtime-theme-read files (nvim looks) are writable out-of-store symlinks to
> this repo. Nix drives starship, wezterm, bat, nvim,
> sketchybar, opencode, spotify-player, and zsh (autosuggestion color) — and,
> on NixOS, Hyprland's borders plus the active wallpaper collection Noctalia
> reads from `~/Pictures` — via the `theme` value (`dotfiles.theme` option);
> `theme-switch` reloads sketchybar (macOS) or Hyprland (NixOS; Noctalia
> hot-reloads its own config).

## Adding a New App to the Theme System

1. If Nix can manage the app's config, add a feature module under
   `modules/features/` that reads `config.dotfiles.theme` (like starship's
   `palette` or bat's `config.theme`). Capture it in a `let theme =
   config.dotfiles.theme; in` binding and bake the result into the
   `flake.modules.homeManager.<name>` value.
2. If the app reads a theme file at runtime, have it read `~/.config/theme`
   (written by Nix from the `theme` value) — like nvim's `looks.lua` or
   sketchybar's `colors.sh`.
3. Only if neither works (out-of-store symlink, Nix can't touch individual
   files), add a `jq`/`sed` block to `bins/theme-switch` under the app's config
   path.
4. For the NixOS desktop, extend the `palettes` set in
   `modules/theme.nix` so Hyprland borders are themed at build
   time, and — for Noctalia — point its wallpaper directory at the active
   theme's collection via `@WALLPAPER_DIR@` in `config/noctalia/config.toml`
   (rendered in `modules/features/noctalia.nix`).

## Requirements

- macOS (aarch64-darwin) *or* NixOS (x86_64-linux, NVIDIA desktop — see `nixos/README.md`)
- [Nix](https://nixos.org/download.html) (with flakes enabled)
- [Homebrew](https://brew.sh) (macOS only)

The nix-darwin flake (with home-manager) installs the rest of the toolchain (`fd`, `bat`/`lsd`/`delta` for shell aliases, `ripgrep`, `starship`, `fzf`, Oh My Zsh, etc.) and deploys all dotfiles. The NixOS host installs the same toolchain via `environment.systemPackages` plus the identical home-manager profile.
