# Hyprland desktop for a NixOS host using UWSM.
# Two classes:
# - nixos.hyprland: system-side compositor/UWSM/XWayland, XDG portals and
#   greetd + tuigreet login (the host module enables UWSM/Hyprland via this).
# - homeManager.hyprland: the user session; intentionally only owns the user
#   config and disables Home Manager's competing systemd unit.
{config, ...}: let
  theme = config.dotfiles.theme;
  palettes = {
    nord = {
      base = "#2e3440";
      surface = "#3b4252";
      text = "#eceff4";
      muted = "#d8dee9";
      accent = "#88c0d0";
      blue = "#81a1c1";
      red = "#bf616a";
    };
    catppuccin = {
      base = "#1e1e2e";
      surface = "#313244";
      text = "#cdd6f4";
      muted = "#a6adc8";
      accent = "#cba6f7";
      blue = "#89b4fa";
      red = "#f38ba8";
    };
    gruvbox = {
      base = "#282828";
      surface = "#3c3836";
      text = "#ebdbb2";
      muted = "#bdae93";
      accent = "#fabd2f";
      blue = "#83a598";
      red = "#fb4934";
    };
  };
  palette = palettes.${theme};
  render = file: builtins.replaceStrings ["@BASE@" "@SURFACE@" "@TEXT@" "@MUTED@" "@ACCENT@" "@BLUE@" "@RED@"] [palette.base palette.surface palette.text palette.muted palette.accent palette.blue palette.red] (builtins.readFile file);
  renderHyprlock = file: builtins.replaceStrings ["#"] [""] (render file);
in {
  config.flake.modules.homeManager.hyprland = {pkgs, ...}: {
    wayland.windowManager.hyprland = {
      enable = true;
      systemd.enable = false;
      xwayland.enable = true;
      settings = {
        monitor = ", preferred, auto, 1";
        env = ["XCURSOR_SIZE,24" "HYPRCURSOR_SIZE,24"];
        exec-once = ["wl-paste --watch cliphist store" "waybar" "mako" "hyprpolkitagent"];
        "$mod" = "ALT";
        "$terminal" = "wezterm";
        "$menu" = "fuzzel";
        input = {
          kb_layout = "us";
          follow_mouse = 1;
          sensitivity = 0;
          touchpad = {natural_scroll = true;};
        };
        general = {
          gaps_in = 6;
          gaps_out = 12;
          border_size = 2;
          "col.active_border" = "rgba(${builtins.substring 1 6 palette.accent}ee)";
          "col.inactive_border" = "rgba(${builtins.substring 1 6 palette.surface}aa)";
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
          pseudotile = true;
          preserve_split = true;
        };
        misc = {
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
        };
      };
      extraConfig = builtins.readFile ../../config/hypr/hyprland.conf;
    };
    programs.waybar = {
      enable = true;
      systemd.enable = false;
    };
    programs.fuzzel.enable = true;
    services.mako.enable = true;
    programs.hyprlock.enable = true;
    services.hypridle.enable = true;
    home.packages = with pkgs; [brightnessctl cliphist grim hyprpolkitagent playerctl slurp wl-clipboard wev pavucontrol wireplumber];
    xdg.configFile."waybar/config".source = ../../config/waybar/config;
    xdg.configFile."waybar/style.css".text = render ../../config/waybar/style.css;
    xdg.configFile."fuzzel/fuzzel.ini".text = render ../../config/fuzzel/fuzzel.ini;
    xdg.configFile."mako/config".text = render ../../config/mako/config;
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
