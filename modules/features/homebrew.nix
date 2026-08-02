# Homebrew — casks and brews not in nixpkgs.
# you still need to install brew manually.
{...}: {
  config.flake.modules.darwin.homebrew = {
    homebrew = {
      enable = true;

      onActivation = {
        autoUpdate = false;
        cleanup = "uninstall";
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
      ];

      brews = [
        "sketchybar"
      ];

      casks = [
        "aerospace"
        "canon-ufrii-driver"
        "firefox"
        "font-sf-pro"
        "obsidian"
        "raycast"
        "sf-symbols"
        "spotify"
        "stats"
        "wechat"
      ];
    };
  };
}
