# my-dotfiles

A curated set of macOS dotfiles with **Nord** / **Catppuccin** theme switching across the entire stack — terminal, editor, window manager, status bar, and prompt.

## Features

- **Unified theme system** — toggle between Nord and Catppuccin across all apps with a single command
- **macOS-first** — AeroSpace (tiling WM), SketchyBar (menu bar), WezTerm, and nix-darwin
- **Minimal Neovim IDE** — lazy.nvim with LSP, DAP, autocompletion, test runner, git integration, and AI copilot
- **WezTerm multiplexer** — WezTerm handles multiplexing natively (tabs, splits, workspaces, copy mode) with tmux-style keybindings (`C-a` leader, `h/j/k/l` navigation). The `tmux/` config is kept as legacy and is not actively used.
- **nix-darwin + home-manager** — declarative system *and* user config (packages, fonts, system settings, dotfiles, bins)

## Quick Start

```bash
# 1. Install dependencies
./clone_dependencies.sh

# 2. (one-time, only if migrating from Stow) remove old Stow symlinks so
#    home-manager can take over the same target paths:
stow -D git wezterm zsh && stow -D --target="$HOME/.config" config

# 3. Build nix-darwin system (this also activates home-manager, which deploys
#    all dotfiles and bins/ to ~/ and ~/.config/):
cd nix && sudo darwin-rebuild switch --flake .#Mac-that-vim

# 4. Restart your shell (or `source ~/.zshrc`) so theme-switch and aliases are on PATH
```

After the first build, `switch` (in `bins/`) reformats, rebuilds, and commits in one step.

## Theme Switching

```bash
theme-switch nord        # apply Nord theme everywhere
theme-switch catppuccin  # apply Catppuccin Mocha everywhere
```

This updates the `theme` var in `home.nix`, rebuilds via Nix (propagating to starship, wezterm, bat, nvim, and sketchybar), then patches opencode's `tui.json` (the one Nix-blind tool) and reloads SketchyBar. WezTerm picks up its config change via file watching. A restart of Neovim and OpenCode is required.

## Structure

```
my-dotfiles/
├── bins/               # Executable helpers (deployed to ~/bin by home-manager)
│   ├── theme-switch          # Theme toggle (Nord ↔ Catppuccin)
│   ├── switch                # nix-darwin rebuild + commit
│   └── tmux-sessionizer      # Fuzzy tmux workspace selector (legacy — WezTerm has a native workspace port)
├── config/             # Deployed to ~/.config/ by home-manager
│   ├── aerospace/            # Tiling window manager
│   ├── gh-dash/              # GitHub CLI dashboard
│   ├── nvim/                 # Neovim (lazy.nvim) — out-of-store symlink (reads ~/.config/theme at startup)
│   ├── opencode/             # OpenCode AI config — out-of-store symlink (theme-switch mutates tui.json)
│   ├── ripgrep/              # Ripgrep config
│   ├── sketchybar/           # macOS menu bar replacement — out-of-store symlink (reads ~/.config/theme at runtime)
│   └── starship/             # Shell prompt — out-of-store symlink (Nix manages palette via `theme` var)
├── git/                # Git config (deployed to ~/.gitconfig by home-manager)
├── nix/                # nix-darwin + home-manager flake
│   └── modules/
│       ├── apps.nix          # System packages + Homebrew casks
│       ├── home.nix          # home-manager: dotfiles + bins deployment
│       └── system.nix        # System settings (keyboard, dock, etc.)
├── tmux/               # Tmux config (legacy — WezTerm multiplexer is active; not deployed)
├── wezterm/            # WezTerm config (deployed to ~/.wezterm.lua — Nix injects scheme_name via `theme` var)
└── zsh/                # Zsh config + aliases (deployed to ~/ by home-manager)
```

## Key Bindings

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
| Plugins  | lazy.nvim       | Neovim plugins                                     |

> home-manager deploys static configs as read-only nix-store symlinks and the
> runtime-theme-read files (sketchybar colors, nvim looks) as writable
> out-of-store symlinks to this repo. Nix drives starship, wezterm, bat, nvim,
> and sketchybar via the `theme` var; `theme-switch` only patches opencode
> (Nix-blind) and reloads sketchybar.

## Adding a New App to the Theme System

1. If Nix can manage the app's config, add a conditional on the `theme` var in
   `home.nix` (like starship's `palette` or bat's `config.theme`).
2. If the app reads a theme file at runtime, have it read `~/.config/theme`
   (written by Nix from the `theme` var) — like nvim's `looks.lua` or
   sketchybar's `colors.sh`.
3. Only if neither works (out-of-store symlink, Nix can't touch individual
   files), add a `jq`/`sed` block to `bins/theme-switch` under the app's config
   path — like opencode's `tui.json`.

## Requirements

- macOS (aarch64-darwin)
- [Nix](https://nixos.org/download.html) (with flakes enabled)
- [Homebrew](https://brew.sh)
- [Oh My Zsh](https://ohmyz.sh)
- [sketchybar-app-font](https://github.com/kvndrsslr/sketchybar-app-font)

The nix-darwin flake (with home-manager) installs the rest of the toolchain (`fd`, `bat`/`lsd`/`delta` for shell aliases, `ripgrep`, `starship`, `fzf`, etc.) and deploys all dotfiles.
