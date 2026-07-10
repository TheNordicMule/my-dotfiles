# wezterm (file-driven; Nix injects scheme_name based on `theme`).
# The Lua file has its scheme_name line stripped; it's prepended here.
# `theme` is captured from the flake-parts top-level config.
{config, ...}: let
  theme = config.dotfiles.theme;
in {
  config.flake.modules.homeManager.wezterm = {
    home.file.".wezterm.lua".text =
      ''
        local scheme_name = "${
          if theme == "catppuccin"
          then "catppuccin-mocha"
          else if theme == "gruvbox"
          then "GruvboxDark"
          else "nord"
        }"
      ''
      + builtins.readFile ../../wezterm/dot-wezterm.lua;
  };
}
