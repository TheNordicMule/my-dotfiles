# tealdeer (typed home-manager module — manages config.toml).
{...}: {
  config.flake.modules.homeManager.tealdeer = {
    programs.tealdeer = {
      enable = true;
    };
  };
}
