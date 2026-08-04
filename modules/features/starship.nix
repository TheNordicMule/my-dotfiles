# starship (typed home-manager module, theme-aware via `palette`).
# `theme` is captured from the flake-parts top-level config; the palette
# definition comes from config.dotfiles.palettes (theme.nix).
{config, ...}: let
  theme = config.dotfiles.theme;
  paletteName =
    if theme == "catppuccin"
    then "catppuccin_mocha"
    else if theme == "gruvbox"
    then "gruvbox"
    else "nord";
in {
  config.flake.modules.homeManager.starship = {
    programs.starship = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        palette = paletteName;
        palettes.${paletteName} = config.dotfiles.palettes.${theme}.starship;

        git_status = {
          conflicted = "🏳";
          ahead = ''🏎💨''${count}'';
          behind = ''🐢''${count}'';
          diverged = "😵";
          untracked = "🤷";
          stashed = "📦";
          modified = "📝";
          staged = ''[++\(''${count}\)](green)'';
          renamed = "👅";
          deleted = "🗑";
        };
      };
    };
  };
}
