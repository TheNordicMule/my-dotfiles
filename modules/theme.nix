# Theme — the single source of truth.
#
# `config.dotfiles.theme` is declared in helpers.nix; its value is set here on
# one line so bins/theme-switch can sed it in place. Every themed feature
# module closes over `config.dotfiles.theme` (captured in a `let` binding at
# flake-parts eval time) and bakes the result into its home-manager module.
# All palettes live here too (`config.dotfiles.palettes`), so adding a theme
# means adding one entry to this file — every consumer picks it up.
{ config, ... }: {
  # ────────────────────────────────────────────────────────────────────────────
  # Theme — change this one variable to switch all themed tools.
  # Valid values: "nord" | "catppuccin" | "gruvbox"
  # bins/theme-switch seds this line in place, then rebuilds.
  # ────────────────────────────────────────────────────────────────────────────
  config.dotfiles.theme = "catppuccin";

  # All palettes, keyed by theme name. Consumers:
  # - base/surface/text/muted/accent/blue/red  → hyprland (borders); Noctalia
  #   bar/wallpaper theming reads the active theme's wallpaper collection via
  #   config/noctalia/config.toml (see modules/features/noctalia.nix)
  # - autosuggest                              → zsh autosuggestion color
  # - starship                                 → full starship palette attrset
  # - spotify                                  → spotify-player palette +
  #   component_style
  config.dotfiles.palettes = {
    nord = {
      base = "#2e3440";
      surface = "#3b4252";
      text = "#eceff4";
      muted = "#d8dee9";
      accent = "#88c0d0";
      blue = "#81a1c1";
      red = "#bf616a";
      autosuggest = "#616e88";
      starship = {
        rosewater = "#d8dee9";
        flamingo = "#d8dee9";
        pink = "#b48ead";
        mauve = "#b48ead";
        red = "#bf616a";
        maroon = "#bf616a";
        peach = "#d08770";
        yellow = "#ebcb8b";
        green = "#a3be8c";
        teal = "#8fbcbb";
        sky = "#88c0d0";
        sapphire = "#81a1c1";
        blue = "#5e81ac";
        lavender = "#81a1c1";
        text = "#eceff4";
        subtext1 = "#e5e9f0";
        subtext0 = "#d8dee9";
        overlay2 = "#4c566a";
        overlay1 = "#434c5e";
        overlay0 = "#3b4252";
        surface2 = "#4c566a";
        surface1 = "#434c5e";
        surface0 = "#3b4252";
        base = "#2e3440";
        mantle = "#2e3440";
        crust = "#2e3440";
      };
      spotify = {
        palette = {
          background = "#2e3440";
          foreground = "#d8dee9";
          black = "#3b4252";
          red = "#bf616a";
          green = "#a3be8c";
          yellow = "#ebcb8b";
          blue = "#81a1c1";
          magenta = "#b48ead";
          cyan = "#88c0d0";
          white = "#e5e9f0";
          bright_black = "#4c566a";
          bright_red = "#bf616a";
          bright_green = "#a3be8c";
          bright_yellow = "#ebcb8b";
          bright_blue = "#81a1c1";
          bright_magenta = "#b48ead";
          bright_cyan = "#8fbcbb";
          bright_white = "#eceff4";
        };
        component_style = {
          block_title = {
            fg = "#88c0d0";
            modifiers = [ "Bold" ];
          };
          border = {
            fg = "#4c566a";
          };
          selection = {
            bg = "#434c5e";
            fg = "#eceff4";
            modifiers = [ "Bold" ];
          };
          playback_status = {
            fg = "#a3be8c";
            modifiers = [ "Bold" ];
          };
          playback_track = {
            fg = "#88c0d0";
            modifiers = [ "Bold" ];
          };
          playback_artists = {
            fg = "#81a1c1";
          };
          playback_progress_bar = {
            bg = "#434c5e";
            fg = "#a3be8c";
          };
          current_playing = {
            fg = "#a3be8c";
            modifiers = [ "Bold" ];
          };
          table_header = {
            fg = "#81a1c1";
            modifiers = [ "Bold" ];
          };
        };
      };
    };
    catppuccin = {
      base = "#1e1e2e";
      surface = "#313244";
      text = "#cdd6f4";
      muted = "#a6adc8";
      accent = "#cba6f7";
      blue = "#89b4fa";
      red = "#f38ba8";
      autosuggest = "#6c7086";
      starship = {
        rosewater = "#f5e0dc";
        flamingo = "#f2cdcd";
        pink = "#f5c2e7";
        mauve = "#cba6f7";
        red = "#f38ba8";
        maroon = "#eba0ac";
        peach = "#fab387";
        yellow = "#f9e2af";
        green = "#a6e3a1";
        teal = "#94e2d5";
        sky = "#89dceb";
        sapphire = "#74c7ec";
        blue = "#89b4fa";
        lavender = "#b4befe";
        text = "#cdd6f4";
        subtext1 = "#bac2de";
        subtext0 = "#a6adc8";
        overlay2 = "#9399b2";
        overlay1 = "#7f849c";
        overlay0 = "#6c7086";
        surface2 = "#585b70";
        surface1 = "#45475a";
        surface0 = "#313244";
        base = "#1e1e2e";
        mantle = "#181825";
        crust = "#11111b";
      };
      spotify = {
        palette = {
          background = "#1e1e2e";
          foreground = "#cdd6f4";
          black = "#45475a";
          red = "#f38ba8";
          green = "#a6e3a1";
          yellow = "#f9e2af";
          blue = "#89b4fa";
          magenta = "#f5c2e7";
          cyan = "#94e2d5";
          white = "#bac2de";
          bright_black = "#585b70";
          bright_red = "#f38ba8";
          bright_green = "#a6e3a1";
          bright_yellow = "#f9e2af";
          bright_blue = "#89b4fa";
          bright_magenta = "#f5c2e7";
          bright_cyan = "#94e2d5";
          bright_white = "#cdd6f4";
        };
        component_style = {
          block_title = {
            fg = "#cba6f7";
            modifiers = [ "Bold" ];
          };
          border = {
            fg = "#585b70";
          };
          selection = {
            bg = "#45475a";
            fg = "#cdd6f4";
            modifiers = [ "Bold" ];
          };
          playback_status = {
            fg = "#a6e3a1";
            modifiers = [ "Bold" ];
          };
          playback_track = {
            fg = "#cba6f7";
            modifiers = [ "Bold" ];
          };
          playback_artists = {
            fg = "#89b4fa";
          };
          playback_progress_bar = {
            bg = "#45475a";
            fg = "#a6e3a1";
          };
          current_playing = {
            fg = "#a6e3a1";
            modifiers = [ "Bold" ];
          };
          table_header = {
            fg = "#89dceb";
            modifiers = [ "Bold" ];
          };
        };
      };
    };
    gruvbox = {
      base = "#282828";
      surface = "#3c3836";
      text = "#ebdbb2";
      muted = "#bdae93";
      accent = "#fabd2f";
      blue = "#83a598";
      red = "#fb4934";
      autosuggest = "#928374";
      starship = {
        rosewater = "#ebdbb2";
        flamingo = "#ebdbb2";
        pink = "#d3869b";
        mauve = "#d3869b";
        red = "#fb4934";
        maroon = "#cc241d";
        peach = "#fe8019";
        yellow = "#fabd2f";
        green = "#b8bb26";
        teal = "#8ec07c";
        sky = "#689d6a";
        sapphire = "#458588";
        blue = "#83a598";
        lavender = "#83a598";
        text = "#fbf1c7";
        subtext1 = "#ebdbb2";
        subtext0 = "#d5c4a1";
        overlay2 = "#bdae93";
        overlay1 = "#a89984";
        overlay0 = "#928374";
        surface2 = "#504945";
        surface1 = "#3c3836";
        surface0 = "#32302f";
        base = "#282828";
        mantle = "#1d2021";
        crust = "#1d2021";
      };
      spotify = {
        palette = {
          background = "#282828";
          foreground = "#ebdbb2";
          black = "#282828";
          red = "#cc241d";
          green = "#98971a";
          yellow = "#d79921";
          blue = "#458588";
          magenta = "#b16286";
          cyan = "#689d6a";
          white = "#a89984";
          bright_black = "#928374";
          bright_red = "#fb4934";
          bright_green = "#b8bb26";
          bright_yellow = "#fabd2f";
          bright_blue = "#83a598";
          bright_magenta = "#d3869b";
          bright_cyan = "#8ec07c";
          bright_white = "#ebdbb2";
        };
        component_style = {
          block_title = {
            fg = "#fabd2f";
            modifiers = [ "Bold" ];
          };
          border = {
            fg = "#665c54";
          };
          selection = {
            bg = "#504945";
            fg = "#ebdbb2";
            modifiers = [ "Bold" ];
          };
          playback_status = {
            fg = "#b8bb26";
            modifiers = [ "Bold" ];
          };
          playback_track = {
            fg = "#fabd2f";
            modifiers = [ "Bold" ];
          };
          playback_artists = {
            fg = "#83a598";
          };
          playback_progress_bar = {
            bg = "#504945";
            fg = "#b8bb26";
          };
          current_playing = {
            fg = "#b8bb26";
            modifiers = [ "Bold" ];
          };
          table_header = {
            fg = "#83a598";
            modifiers = [ "Bold" ];
          };
        };
      };
    };
  };

  # Runtime theme file — read by nvim (looks.lua) and sketchybar (colors.sh).
  # The value is baked in from the top-level config at flake-parts eval time.
  config.flake.modules.homeManager.theme-runtime = {
    xdg.configFile."theme".text = config.dotfiles.theme;
  };
}
