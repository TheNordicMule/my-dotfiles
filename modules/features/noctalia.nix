# Noctalia v5 — the NixOS-desktop Wayland shell/bar.
#
# Home Manager installs the nixpkgs package and deploys its rendered TOML.
# Hyprland autostarts Noctalia in the user session.
{
  config,
  ...
}:
let
  wallsDirName = if config.dotfiles.theme == "nord" then "walls-nordic" else "walls-catppuccin-mocha";
in
{
  config.flake.modules.homeManager.noctalia = { pkgs, ... }: {
    home.packages = [ pkgs.noctalia ];
    xdg.configFile."noctalia/config.toml".text =
      builtins.replaceStrings [ "@WALLPAPER_DIR@" ] [ wallsDirName ]
        (builtins.readFile ../../config/noctalia/config.toml);
  };
}
