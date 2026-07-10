# my-dotfiles

A curated set of macOS dotfiles with **Nord** / **Catppuccin** / **Gruvbox** theme switching across the entire stack — terminal, editor, window manager, status bar, and prompt.

## Features

- **Unified theme system** — toggle between Nord, Catppuccin, and Gruvbox across all apps with a single command
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
sudo darwin-rebuild switch --flake .#Mac-that-vim

# 4. Restart your shell (or `source ~/.zshrc`) so theme-switch and aliases are on PATH
```

After the first build, `switch` (in `bins/`) reformats, rebuilds, and commits in one step.

## Theme Switching

```bash
theme-switch nord        # apply Nord theme everywhere
theme-switch catppuccin  # apply Catppuccin Mocha everywhere
theme-switch gruvbox     # apply Gruvbox everywhere
```

This updates the `theme` value in `modules/theme.nix`, rebuilds via Nix (propagating to starship, wezterm, bat, nvim, sketchybar, and opencode's TUI theme) and reloads SketchyBar. WezTerm picks up its config change via file watching. A restart of Neovim and OpenCode is required.

## Structure

```
my-dotfiles/
├── flake.nix                 # Thin root: inputs + flake-parts + import-tree (auto-imports modules/)
├── flake.lock
├── modules/                  # Auto-imported — every .nix file is a flake-parts module
│   ├── flake-parts.nix       #   Registers the `flake.modules` option
│   ├── helpers.nix           #   Declares `flake.darwinConfigurations` + `dotfiles.theme` option
│   ├── theme.nix             #   Sets the theme value (single sed-editable line) + runtime theme file
│   ├── host-mac-that-vim.nix #   Assembles darwinConfigurations."Mac-that-vim" from features
│   ├── users/
│   │   └── mingshiwang.nix   #   home-manager base + selects which feature modules to import
│   └── features/             #   One file per capability (dendritic: organize by feature, not host)
│       ├── base.nix          #     darwin: primary user, nix daemon, fonts, shell
│       ├── system.nix        #     darwin: keyboard, dock, touch-id, menu bar
│       ├── packages.nix      #     darwin: environment.systemPackages
│       ├── homebrew.nix      #     darwin: taps / brews / casks
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
│       ├── opencode.nix      #     HM: opencode (programs.opencode, theme-aware)
│       ├── static-configs.nix#     HM: aerospace, gh-dash (read-only nix-store)
│       └── bins.nix          #     HM: switch, theme-switch, tmux-sessionizer on $PATH
├── bins/                     # Executable helpers (deployed to ~/bin by home-manager)
│   ├── switch                #   darwin-rebuild switch + commit
│   ├── theme-switch          #   Theme toggle (Nord / Catppuccin / Gruvbox)
│   └── tmux-sessionizer      #   Fuzzy tmux workspace selector (legacy)
├── config/                   # Deployed to ~/.config/ by home-manager
│   ├── aerospace/            #   Tiling window manager
│   ├── gh-dash/              #   GitHub CLI dashboard
│   ├── nvim/                 #   Neovim (lazy.nvim) — out-of-store symlink (reads ~/.config/theme at startup)
│   ├── opencode/             #   OpenCode AI — oh-my-opencode-slim preset (out-of-store symlink); config via programs.opencode
│   └── sketchybar/           #   macOS menu bar — out-of-store symlink (reads ~/.config/theme at runtime)
├── wezterm/                  # WezTerm Lua config (Nix injects scheme_name based on `theme`)
├── tmux/                     # Tmux config (legacy — WezTerm multiplexer is active; not deployed)
└── README.md
```

The config uses the **dendritic pattern**: every `.nix` file under `modules/` is a top-level flake-parts module, auto-discovered by [import-tree](https://github.com/vic/import-tree) — no manual imports list to maintain. Feature files set `flake.modules.darwin.<name>` and/or `flake.modules.homeManager.<name>`; the host file assembles a `darwinConfiguration` from them. The `theme` value lives in one place (`modules/theme.nix`, declared as the `dotfiles.theme` option in `helpers.nix`) and is read by every themed feature module.

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
> sketchybar, and opencode via the `theme` value (`dotfiles.theme` option);
> `theme-switch` only reloads sketchybar.

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

## Requirements

- macOS (aarch64-darwin)
- [Nix](https://nixos.org/download.html) (with flakes enabled)
- [Homebrew](https://brew.sh)

The nix-darwin flake (with home-manager) installs the rest of the toolchain (`fd`, `bat`/`lsd`/`delta` for shell aliases, `ripgrep`, `starship`, `fzf`, Oh My Zsh, etc.) and deploys all dotfiles.
