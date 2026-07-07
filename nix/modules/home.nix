# Home-manager user configuration.
#
# Two deployment strategies are used:
#   1. Static configs  -> nix-store symlinks (read-only, reproducible, versioned)
#   2. Mutable configs -> out-of-store symlinks to the repo (writable)
#
# The mutable bucket exists because `bins/theme-switch` rewrites those files at
# runtime via `cat >` / `sed -i`. nix-store paths are read-only, so those files
# must point back to the real repo tree to stay editable.
{
  config,
  lib,
  ...
}: {
  home.username = "mingshiwang";
  # mkForce: home-manager's darwin common module derives this from
  # `users.users.<name>.home`, which is null on nix-darwin (existing macOS
  # users aren't declared in `users.users`). Override that derivation rather
  # than declaring the user (which would trigger nix-darwin user management).
  home.homeDirectory = lib.mkForce "/Users/mingshiwang";
  home.stateVersion = "24.11";

  xdg.enable = true;

  # --- Static dotfiles (nix-store, reproducible) ---
  home.file.".gitconfig".source = ../../git/dot-gitconfig;
  home.file.".zshrc".source = ../../zsh/dot-zshrc;
  home.file.".zsh_aliases".source = ../../zsh/dot-zsh_aliases;

  xdg.configFile."aerospace".source = ../../config/aerospace;
  xdg.configFile."gh-dash".source = ../../config/gh-dash;
  xdg.configFile."ripgrep".source = ../../config/ripgrep;

  # --- Executable helpers on $PATH (see zsh/dot-zshrc: export PATH="$HOME/bin:...") ---
  home.file."bin/theme-switch".source = ../../bins/theme-switch;
  home.file."bin/switch".source = ../../bins/switch;
  home.file."bin/tmux-sessionizer".source = ../../bins/tmux-sessionizer;

  # --- Mutable configs (theme-switch rewrites these at runtime) ---
  # Out-of-store symlinks to the repo so `sed -i` / `cat >` land on real,
  # writable files and running programs pick up the change immediately.
  xdg.configFile."sketchybar".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/my-dotfiles/config/sketchybar";
  xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/my-dotfiles/config/nvim";
  xdg.configFile."opencode".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/my-dotfiles/config/opencode";
  xdg.configFile."starship".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/my-dotfiles/config/starship";
  home.file.".wezterm.lua".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/my-dotfiles/wezterm/dot-wezterm.lua";
}
