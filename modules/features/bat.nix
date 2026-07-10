# bat (typed home-manager module, theme-aware via `theme`).
# catppuccin theme is fetched from catppuccin/bat; nord and gruvbox-dark are
# bundled with bat. `pkgs` comes from the HM evaluation (not flake-parts).
{config, ...}: let
  theme = config.dotfiles.theme;
in {
  config.flake.modules.homeManager.bat = {pkgs, lib, ...}: {
    programs.bat = {
      enable = true;
      themes = lib.optionalAttrs (theme == "catppuccin") {
        "Catppuccin Mocha" = {
          src = pkgs.fetchFromGitHub {
            owner = "catppuccin";
            repo = "bat";
            rev = "6810349b28055dce54076712fc05fc68da4b8ec0";
            sha256 = "sha256-lJapSgRVENTrbmpVyn+UQabC9fpV1G1e+CdlJ090uvg=";
          };
          file = "themes/Catppuccin Mocha.tmTheme";
        };
      };
      config.theme =
        if theme == "catppuccin"
        then "Catppuccin Mocha"
        else if theme == "gruvbox"
        then "gruvbox-dark"
        else "Nord";
    };
  };
}
