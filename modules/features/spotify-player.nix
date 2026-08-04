# spotify-player — terminal Spotify client (requires Spotify Premium).
# Theme palettes come from config.dotfiles.palettes (theme.nix); all three are
# baked in so the in-app theme can be cycled, with the active one preselected.
{config, ...}: {
  config.flake.modules.homeManager.spotify-player = {...}: {
    programs.spotify-player = {
      enable = true;
      themes = [
        {
          name = "catppuccin";
          inherit (config.dotfiles.palettes.catppuccin.spotify) palette component_style;
        }
        {
          name = "nord";
          inherit (config.dotfiles.palettes.nord.spotify) palette component_style;
        }
        {
          name = "gruvbox";
          inherit (config.dotfiles.palettes.gruvbox.spotify) palette component_style;
        }
      ];
      settings = {
        theme = config.dotfiles.theme;
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
