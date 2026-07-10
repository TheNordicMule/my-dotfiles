# starship (typed home-manager module, theme-aware via `palette`).
# `theme` is captured from the flake-parts top-level config; the chosen palette
# name and the full palettes attrset are baked into the HM module.
{config, ...}: let
  theme = config.dotfiles.theme;
in {
  config.flake.modules.homeManager.starship = {
    programs.starship = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        palette =
          if theme == "catppuccin"
          then "catppuccin_mocha"
          else if theme == "gruvbox"
          then "gruvbox"
          else "nord";

        palettes = {
          catppuccin_mocha = {
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
          nord = {
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
          gruvbox = {
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
        };

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
