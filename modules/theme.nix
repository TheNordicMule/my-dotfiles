# Theme — the single source of truth.
#
# `config.dotfiles.theme` is declared in helpers.nix; its value is set here on
# one line so bins/theme-switch can sed it in place. Every themed feature
# module closes over `config.dotfiles.theme` (captured in a `let` binding at
# flake-parts eval time) and bakes the result into its home-manager module.
{config, ...}: {
  # ────────────────────────────────────────────────────────────────────────────
  # Theme — change this one variable to switch all themed tools.
  # Valid values: "nord" | "catppuccin" | "gruvbox"
  # bins/theme-switch seds this line in place, then rebuilds.
  # ────────────────────────────────────────────────────────────────────────────
  config.dotfiles.theme = "catppuccin";

  # Runtime theme file — read by nvim (looks.lua) and sketchybar (colors.sh).
  # The value is baked in from the top-level config at flake-parts eval time.
  config.flake.modules.homeManager.theme-runtime = {
    xdg.configFile."theme".text = config.dotfiles.theme;
  };
}
