# Noctalia v5 — the NixOS-desktop Wayland shell/bar and its greetd login.
#
# Home Manager installs the nixpkgs package and deploys its rendered TOML.
# Hyprland autostarts Noctalia in the user session.
# The nixos.noctalia class module (below) replaces the former tuigreet login
# with Noctalia Greeter; the nixpkgs module owns greetd's defaults, so
# hyprland.nix no longer configures greetd.
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

  # System side: Noctalia Greeter, the graphical greetd login that matches the
  # shell. The nixpkgs module enables greetd itself and makes
  # `noctalia-greeter-session` the `default_session` command, so this replaces
  # the manual tuigreet session that used to live in hyprland.nix.
  config.flake.modules.nixos.noctalia = { ... }: {
    services.displayManager.noctalia-greeter = {
      enable = true;
      # Constrained, appearance-only sync from Noctalia Shell (Settings →
      # Security → Noctalia Greeter → Sync Now) without an admin prompt. This
      # never accepts session-command configuration (see the nixpkgs module).
      passwordlessSyncUsers = [ "mingshiwang" ];
      settings = {
        # Same single-user convenience as tuigreet's remembered user.
        user.default = "mingshiwang";
        # Keep the UWSM-managed Hyprland session (matches the old
        # `uwsm start Hyprland` greetd command).
        session.default = "Hyprland (uwsm-managed)";
        keyboard.layout = "us";
      };
    };
  };
}
