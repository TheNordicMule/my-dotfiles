# Homebrew — casks and brews not in nixpkgs.
# you still need to install brew manually.
{...}: {
  config.flake.modules.darwin.homebrew = {
    homebrew = {
      enable = true;

      onActivation = {
        autoUpdate = false;
        cleanup = "zap";
      };

      taps = [
        "homebrew/bundle"
        "homebrew/cask-drivers"
        "homebrew/cask-fonts"
        "homebrew/cask-versions"
        "homebrew/services"
        {
          name = "nikitabobko/tap";
          trusted = true;
        }
        {
          name = "felixkratz/formulae";
          trusted = true;
        }
        "anomalyco/tap"
      ];

      brews = [
        "sketchybar"
        "opencode"
      ];

      casks = [
        "aerospace"
        "canon-ufrii-driver"
        "font-sf-pro"
        "raycast"
        "sf-symbols"
        "spotify"
        "stats"
        "wechat"
      ];
    };
  };
}
