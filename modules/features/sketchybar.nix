# sketchybar (read-only nix-store; colors.sh reads ~/.config/theme at runtime).
{...}: {
  config.flake.modules.homeManager.sketchybar = {
    xdg.configFile."sketchybar".source = ../../config/sketchybar;
  };
}
