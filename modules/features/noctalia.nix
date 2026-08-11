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

    # Keep Fcitx's enabled input methods declarative. Without this profile,
    # Fcitx starts with only the US keyboard even though Pinyin is installed.
    xdg.configFile."fcitx5/profile".text = ''
      [Groups/0]
      Name=Default
      Default Layout=us
      DefaultIM=pinyin

      [Groups/0/Items/0]
      Name=keyboard-us
      Layout=

      [Groups/0/Items/1]
      Name=pinyin
      Layout=

      [GroupOrder]
      0=Default
    '';

    xdg.configFile."noctalia/config.toml".text =
      builtins.replaceStrings [ "@WALLPAPER_DIR@" ] [ wallsDirName ]
        (builtins.readFile ../../config/noctalia/config.toml);
  };
}
