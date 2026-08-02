# spotify-player — terminal Spotify client (requires Spotify Premium).
{config, ...}: let
  theme = config.dotfiles.theme;
in {
  config.flake.modules.homeManager.spotify-player = {...}: {
    programs.spotify-player = {
      enable = true;
      themes = [
        {
          name = "catppuccin";
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
              modifiers = ["Bold"];
            };
            border = {fg = "#585b70";};
            selection = {
              bg = "#45475a";
              fg = "#cdd6f4";
              modifiers = ["Bold"];
            };
            playback_status = {
              fg = "#a6e3a1";
              modifiers = ["Bold"];
            };
            playback_track = {
              fg = "#cba6f7";
              modifiers = ["Bold"];
            };
            playback_artists = {fg = "#89b4fa";};
            playback_progress_bar = {
              bg = "#45475a";
              fg = "#a6e3a1";
            };
            current_playing = {
              fg = "#a6e3a1";
              modifiers = ["Bold"];
            };
            table_header = {
              fg = "#89dceb";
              modifiers = ["Bold"];
            };
          };
        }
        {
          name = "nord";
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
              modifiers = ["Bold"];
            };
            border = {fg = "#4c566a";};
            selection = {
              bg = "#434c5e";
              fg = "#eceff4";
              modifiers = ["Bold"];
            };
            playback_status = {
              fg = "#a3be8c";
              modifiers = ["Bold"];
            };
            playback_track = {
              fg = "#88c0d0";
              modifiers = ["Bold"];
            };
            playback_artists = {fg = "#81a1c1";};
            playback_progress_bar = {
              bg = "#434c5e";
              fg = "#a3be8c";
            };
            current_playing = {
              fg = "#a3be8c";
              modifiers = ["Bold"];
            };
            table_header = {
              fg = "#81a1c1";
              modifiers = ["Bold"];
            };
          };
        }
        {
          name = "gruvbox";
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
              modifiers = ["Bold"];
            };
            border = {fg = "#665c54";};
            selection = {
              bg = "#504945";
              fg = "#ebdbb2";
              modifiers = ["Bold"];
            };
            playback_status = {
              fg = "#b8bb26";
              modifiers = ["Bold"];
            };
            playback_track = {
              fg = "#fabd2f";
              modifiers = ["Bold"];
            };
            playback_artists = {fg = "#83a598";};
            playback_progress_bar = {
              bg = "#504945";
              fg = "#b8bb26";
            };
            current_playing = {
              fg = "#b8bb26";
              modifiers = ["Bold"];
            };
            table_header = {
              fg = "#83a598";
              modifiers = ["Bold"];
            };
          };
        }
      ];
      settings = {
        theme = theme;
        device = {
          audio_cache = true;
          normalization = true;
          volume = 70;
          bitrate = 320;
        };
      };
    };
  };
}
