# LocalSend — cross-platform, offline file sharing (AirDrop-style over LAN).
# GUI desktop app; installed through the home-manager profile, not the
# system package set.
{...}: {
  config.flake.modules.homeManager.localsend = {pkgs, ...}: {
    home.packages = [pkgs.localsend];
  };
}
