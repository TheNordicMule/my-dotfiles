# Shared option declarations used across the dendritic module tree.
{lib, ...}: {
  # flake-parts does not declare darwinConfigurations by default (nix-darwin's
  # own flake-module would, but we don't import it). Declare it here so the
  # host module can set it cleanly without relying on the freeform `flake`
  # attrset.
  options.flake.darwinConfigurations = lib.mkOption {
    type = lib.types.attrsOf lib.types.raw;
    default = {};
  };

  options.flake.darwinPackages = lib.mkOption {
    type = lib.types.raw;
    default = {};
  };

  # The single source of truth for theming. Read by every themed feature
  # module (starship, wezterm, bat, zsh) via `config.dotfiles.theme`. The
  # value is set in modules/theme.nix on one sed-editable line so
  # bins/theme-switch can rewrite it in place.
  options.dotfiles.theme = lib.mkOption {
    type = lib.types.enum ["nord" "catppuccin" "gruvbox"];
  };
}
