# Static configs (no HM module exists — deployed as read-only nix-store).
{...}: {
  config.flake.modules.homeManager.static-configs = {
    xdg.configFile."aerospace".source = ../../config/aerospace;
    xdg.configFile."gh-dash".source = ../../config/gh-dash;
  };
}
