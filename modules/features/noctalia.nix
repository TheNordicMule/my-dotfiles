# Noctalia v5 — the NixOS-desktop Wayland shell/bar.
#
# Wired permanently into the nixos-desktop host; macOS never imports these
# modules (only modules/hosts/nixos-desktop.nix selects them).
#
# NixOS side (flake.modules.nixos.noctalia): imports Noctalia's official
# `nixosModules.default`, enabling `programs.noctalia` with its recommended
# services (NetworkManager, BlueZ, UPower, power-profiles-daemon) and with the
# systemd user service disabled — Hyprland autostarts `noctalia` in the session
# instead, so there is exactly one Noctalia process and no duplicate service.
#
# Home Manager side (flake.modules.homeManager.noctalia): imports Noctalia's
# official `homeModules.default` so the bar config deploys as
# ~/.config/noctalia/config.toml and is validated at build time. `systemd.enable
# = false` (Hyprland starts it). `settings` renders the designer-owned
# config/noctalia/config.toml and substitutes the wallpaper and palette
# placeholders with the active theme's values, so neither reaches runtime and
# the file stays raw TOML.
{
  config,
  inputs,
  ...
}: let
  # Noctalia palette names follow the repo theme name; wallpaper collections do not.
  noctaliaThemes = {
    nord = "Nord";
    catppuccin = "Catppuccin";
    gruvbox = "Gruvbox";
  };
  noctaliaTheme = builtins.getAttr config.dotfiles.theme noctaliaThemes;
  wallsDirName =
    if config.dotfiles.theme == "nord"
    then "walls-nordic"
    else "walls-catppuccin-mocha";
in {
  config.flake.modules.homeManager.noctalia = {noctalia, ...}: {
    imports = [noctalia.homeModules.default];
    programs.noctalia = {
      enable = true;
      systemd.enable = false;
      settings =
        builtins.replaceStrings
        ["@WALLPAPER_DIR@" "@NOCTALIA_THEME@"]
        [wallsDirName noctaliaTheme]
        (builtins.readFile ../../config/noctalia/config.toml);
    };
  };

  config.flake.modules.nixos.noctalia = {
    imports = [inputs.noctalia.nixosModules.default];
    programs.noctalia = {
      enable = true;
      systemd.enable = false;
      recommendedServices.enable = true;
    };
  };
}
