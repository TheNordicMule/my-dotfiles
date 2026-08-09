# Hyprland desktop for a NixOS host using UWSM.
# Two classes:
# - nixos.hyprland: system-side compositor/UWSM/XWayland, XDG portals and
#   greetd + tuigreet login (the host module enables UWSM/Hyprland via this).
# - homeManager.hyprland: the user session; intentionally only owns the user
#   config and disables Home Manager's competing systemd unit.
# Colors come from config.dotfiles.palettes.${theme} (defined in theme.nix).
{ config, ... }:
let
  palette = config.dotfiles.palettes.${config.dotfiles.theme};
  # Theme is captured from the flake-parts top-level config (theme.nix);
  # bins/theme-switch seds it in place and rebuilds, so the wallpaper
  # collection linked below follows the active theme.
  theme = config.dotfiles.theme;
  # Active wallpaper collection dir name: Nord → nordic-wallpapers, anything
  # else → Catppuccin (preserves the previous default). Only the active
  # theme's collection is linked into the home tree (see home.file below);
  # Noctalia reads it from ~/Pictures (config/noctalia/config.toml's
  # @WALLPAPER_DIR@, rendered in modules/features/noctalia.nix).
  wallsDirName = if theme == "nord" then "walls-nordic" else "walls-catppuccin-mocha";
in
{
  config.flake.modules.homeManager.hyprland =
    {
      pkgs,
      lib,
      config,
      walls-catppuccin-mocha,
      walls-nordic,
      ...
    }:
    let
      # Only the active theme's collection is linked (the inactive input stays
      # in the flake store, untouched).
      walls = if theme == "nord" then walls-nordic else walls-catppuccin-mocha;
    in
    {
      wayland.windowManager.hyprland = {
        enable = true;
        # Lua config (Hyprland ≥ 0.55). `settings` maps to `hl.<name>(...)`
        # calls (vars via `_var`, multi-arg calls via `_args`); the binds live in
        # config/hypr/binds.lua and are appended as extraConfig so they can use
        # the `mod`/`terminal`/`menu` locals generated below.
        configType = "lua";
        systemd.enable = false;
        xwayland.enable = true;
        settings = {
          mod = {
            _var = "SUPER";
          };
          terminal = {
            _var = "wezterm";
          };
          # Launcher local used by binds.lua (Alt+Space) → Noctalia's launcher
          # panel (see config/hypr/binds.lua for the other Noctalia bindings).
          menu = {
            _var = "noctalia msg panel-toggle launcher";
          };

          monitor = {
            output = "";
            mode = "3840x2160@160";
            position = "auto";
            scale = "2";
          };
          env = [
            {
              _args = [
                "XCURSOR_SIZE"
                "24"
              ];
            }
            {
              _args = [
                "HYPRCURSOR_SIZE"
                "24"
              ];
            }
          ];

          # Autostart (the Lua equivalent of exec-once). `noctalia` is the one
          # Noctalia process: it provides the bar, notification daemon, polkit
          # agent and clipboard watcher (see config/noctalia/config.toml), so no
          # legacy agents/watchers are started here.
          on = {
            _args = [
              "hyprland.start"
              (lib.generators.mkLuaInline ''
                function()
                  hl.exec_cmd("noctalia")
                end
              '')
            ];
          };

          config = {
            input = {
              kb_layout = "us";
              kb_options = "caps:escape";
              follow_mouse = 1;
              sensitivity = 0;
              touchpad = {
                natural_scroll = true;
              };
            };
            general = {
              gaps_in = 6;
              gaps_out = 12;
              border_size = 2;
              col = {
                active_border = "rgba(${builtins.substring 1 6 palette.accent}ee)";
                inactive_border = "rgba(${builtins.substring 1 6 palette.surface}aa)";
              };
              layout = "dwindle";
            };
            decoration = {
              rounding = 10;
              blur = {
                enabled = true;
                size = 5;
                passes = 2;
              };
              shadow = {
                enabled = true;
                range = 18;
                render_power = 3;
              };
            };
            animations = {
              enabled = true;
              animation = [
                "windows, 1, 3, snappy, popin"
                "windowsOut, 1, 3, snappy, popin"
                "windowsMove, 1, 4, snappy"
                "border, 1, 3, snappy"
                "fade, 1, 3, snappy"
                "workspaces, 1, 3, snappy, slide"
              ];
            };
            bezier = [
              "snappy, 0.16, 1, 0.3, 1.05"
            ];
            dwindle = {
              preserve_split = true;
            };
            misc = {
              disable_hyprland_logo = true;
              disable_splash_rendering = true;
            };
          };
        };
        extraConfig = builtins.readFile ../../config/hypr/binds.lua;
      };

      # Pin the active theme's wallpaper collection into the home tree (managed
      # by HM — a symlink into the flake store, no manual clone). Noctalia's
      # wallpaper module points at this directory (config/noctalia/config.toml).
      home.file."Pictures/${wallsDirName}" = {
        source = walls;
      };

      home.packages = with pkgs; [
        brightnessctl
        ddcutil
        mangohud
        playerctl
        wev
        wireplumber
      ];
    };

  # System side: compositor under UWSM, portals, and the greetd+tuigreet login.
  config.flake.modules.nixos.hyprland = { pkgs, ... }: {
    # Hyprland (UWSM + XWayland).
    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
      # Launch via UWSM (systemd-supervised Wayland session).
      withUWSM = true;
    };

    # XDG desktop portals: `programs.hyprland` already wires its own portal
    # (xdg-desktop-portal-hyprland) and the GTK portal (via the wayland-session
    # helper) into xdg.portal.extraPortals, so adding them here again would
    # duplicate them. Just make sure the portal machinery is enabled.
    xdg.portal.enable = true;

    # Login: greetd + tuigreet (greetd module creates the `greeter` system
    # user itself). Launch the actual `Hyprland` executable (case-sensitive)
    # under UWSM.
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd 'uwsm start Hyprland'";
          user = "greeter";
        };
      };
    };
  };
}
