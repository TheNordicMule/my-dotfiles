# Hyprland desktop for a NixOS host using UWSM.
# Two classes:
# - nixos.hyprland: system-side compositor/UWSM/XWayland, XDG portals and
#   greetd + tuigreet login (the host module enables UWSM/Hyprland via this).
# - homeManager.hyprland: the user session; intentionally only owns the user
#   config and disables Home Manager's competing systemd unit.
# Colors come from config.dotfiles.palettes.${theme} (defined in theme.nix).
{config, ...}: let
  palette = config.dotfiles.palettes.${config.dotfiles.theme};
  render = file: builtins.replaceStrings ["@BASE@" "@SURFACE@" "@TEXT@" "@MUTED@" "@ACCENT@" "@BLUE@" "@RED@"] [palette.base palette.surface palette.text palette.muted palette.accent palette.blue palette.red] (builtins.readFile file);
  renderHyprlock = file: builtins.replaceStrings ["#"] [""] (render file);
in {
  config.flake.modules.homeManager.hyprland = {
    pkgs,
    lib,
    ...
  }: {
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
        mod = {_var = "SUPER";};
        terminal = {_var = "wezterm";};
        menu = {_var = "fuzzel";};

        monitor = {
          output = "";
          mode = "1920x1080";
          position = "auto";
          scale = "1";
        };
        env = [
          {_args = ["XCURSOR_SIZE" "24"];}
          {_args = ["HYPRCURSOR_SIZE" "24"];}
        ];

        # Autostart (the Lua equivalent of exec-once).
        on = {
          _args = [
            "hyprland.start"
            (lib.generators.mkLuaInline ''
              function()
                hl.exec_cmd("wl-paste --watch cliphist store")
                hl.exec_cmd("waybar")
                hl.exec_cmd("hyprpolkitagent")
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
            touchpad = {natural_scroll = true;};
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
          animations = {enabled = true;};
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
    programs.waybar = {
      enable = true;
      systemd.enable = false;
    };
    services.swaync = {
      enable = true;
      settings = {
        positionX = "right";
        positionY = "top";
        control-center-positionX = "right";
        control-center-positionY = "top";
        control-center-margin-top = 42;
        control-center-margin-right = 12;
        control-center-layer = "overlay";
        control-center-exclusive-zone = false;
        layer = "overlay";
        layer-shell = true;
        fit-to-screen = false;
        control-center-width = 360;
        control-center-height = -1;
        notification-window-width = 360;
        widgets = ["title" "dnd" "mpris" "notifications"];
        widget-config = {
          title = {
            text = "Control Center";
            clear-all-button = true;
            button-text = "Clear";
          };
          dnd = {text = "Do Not Disturb";};
          mpris = {
            autohide = true;
            show-album-art = "when-available";
          };
        };
      };
      style = render ../../config/swaync/style.css;
    };
    programs.fuzzel.enable = true;
    programs.hyprlock.enable = true;
    services.hypridle.enable = true;
    home.packages = with pkgs; [brightnessctl cliphist grim hyprpolkitagent playerctl slurp wl-clipboard wev pavucontrol wireplumber];
    xdg.configFile."waybar/config".source = ../../config/waybar/config;
    xdg.configFile."waybar/style.css".text = render ../../config/waybar/style.css;
    xdg.configFile."fuzzel/fuzzel.ini".text = render ../../config/fuzzel/fuzzel.ini;
    xdg.configFile."hypr/hypridle.conf".source = ../../config/hypr/hypridle.conf;
    xdg.configFile."hypr/hyprlock.conf".text = renderHyprlock ../../config/hypr/hyprlock.conf;
  };

  # System side: compositor under UWSM, portals, and the greetd+tuigreet login.
  config.flake.modules.nixos.hyprland = {pkgs, ...}: {
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
