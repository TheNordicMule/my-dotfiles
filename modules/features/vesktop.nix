# Vesktop — Discord client (managed via Home Manager home.packages).
{...}: {
  config.flake.modules.homeManager.vesktop = {pkgs, ...}: {
    home.packages = with pkgs; [vesktop];
  };
}
