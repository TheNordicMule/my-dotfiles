# my-dotfiles

A curated set of macOS dotfiles with **Nord** / **Catppuccin** theme switching across the entire stack — terminal, editor, window manager, status bar, and prompt.

## Features

- **Unified theme system** — toggle between Nord and Catppuccin across all apps with a single command
- **macOS-first** — AeroSpace (tiling WM), SketchyBar (menu bar), WezTerm, and nix-darwin
- **Minimal Neovim IDE** — LSP, DAP, autocompletion, test runner, git integration, and AI copilot
- **Tmux muscle memory** — WezTerm configured with tmux-style keybindings (`C-a` leader, `h/j/k/l` navigation)
- **nix-darwin** — declarative system config (packages, fonts, system settings)

## Quick Start

```bash
# 1. Install dependencies
./clone_dependencies.sh

# 2. Symlink configs via GNU Stow
./reset_config.sh

# 3. Build nix-darwin system
cd nix && sudo darwin-rebuild switch --flake .#Mac-that-vim
```

## Theme Switching

```bash
theme-switch nord        # apply Nord theme everywhere
theme-switch catppuccin  # apply Catppuccin Mocha everywhere
```

This rewrites colorscheme configs and reloads SketchyBar + tmux automatically. A restart of Neovim and OpenCode is required.

## Structure

```
my-dotfiles/
├── bins/               # Executable helpers
│   ├── theme-switch          # Theme toggle (Nord ↔ Catppuccin)
│   ├── switch                # nix-darwin rebuild + commit
│   └── tmux-sessionizer      # Fuzzy tmux workspace selector
├── config/             # Stowed to ~/.config/
│   ├── aerospace/            # Tiling window manager
│   ├── gh-dash/              # GitHub CLI dashboard
│   ├── nvim/                 # Neovim (LazyVim-style)
│   ├── opencode/             # OpenCode AI config
│   ├── ripgrep/              # Ripgrep config
│   ├── sketchybar/           # macOS menu bar replacement
│   └── starship/             # Shell prompt
├── nix/                # nix-darwin flake
│   └── modules/
│       ├── apps.nix          # System packages + Homebrew casks
│       └── system.nix        # System settings (keyboard, dock, etc.)
├── tmux/               # Tmux config (stowed to ~/)
├── wezterm/            # WezTerm config (stowed to ~/)
└── zsh/                # Zsh config + aliases (stowed to ~/)
```

## Key Bindings

### AeroSpace (Window Manager)

| Binding | Action |
|---|---|
| `alt-1` through `alt-0` | Switch workspace |
| `alt-h/j/k/l` | Focus window left/down/up/right |
| `alt-shift-h/j/k/l` | Move window left/down/up/right |
| `alt-t` | Toggle float/tile |
| `alt-f` | Fullscreen |
| `alt-shift-space` | Cycle layout |

### WezTerm

| Binding | Action |
|---|---|
| `C-a c` | New tab |
| `C-a v` / `C-a s` | Vertical / horizontal split |
| `C-a h/j/k/l` | Navigate panes |
| `C-f` | Sessionizer (fuzzy workspace selector) |
| `C-a [` | Copy mode (vi-style) |

### Neovim

| Binding | Action |
|---|---|
| `<leader>y` / `<leader>p` | System clipboard yank/paste |
| `<leader>d` | Black-hole delete |
| `]e` / `[e` | Next/previous diagnostic |
| `]w` / `[w` | Next/previous warning |
| `Q` | Repeat last macro |

## Package Management

| Layer | Tool | Manages |
|---|---|---|
| System | nix-darwin | Packages, fonts, system settings, Homebrew casks |
| User | Homebrew | Casks not in nixpkgs (AeroSpace, SketchyBar, etc.) |
| Dotfiles | GNU Stow | Symlinks configs to their expected locations |
| Plugins | lazy.nvim | Neovim plugins |

## Adding a New App to the Theme System

1. Add color variables to `bins/theme-switch` for both Nord and Catppuccin
2. Update the app's config to reference the color variables (or use `sed` to swap values)
3. Optionally add a reload hook at the bottom of the script

## Requirements

- macOS (aarch64-darwin)
- [Nix](https://nixos.org/download.html) (with flakes enabled)
- [Homebrew](https://brew.sh)
- [GNU Stow](https://www.gnu.org/software/stow/)
- [Oh My Zsh](https://ohmyz.sh)
- [sketchybar-app-font](https://github.com/kvndrsslr/sketchybar-app-font)
