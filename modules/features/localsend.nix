# LocalSend — cross-platform, offline file sharing (AirDrop-style over LAN).
# - homeManager: GUI desktop app; installed through the home-manager profile,
#   not the system package set.
# - nixos: LocalSend listens on port 53317 — the NixOS host must open it for
#   inbound TCP (control) and UDP (discovery) so devices on the LAN can find
#   and transfer files.
{ ... }: {
  config.flake.modules.homeManager.localsend = { pkgs, ... }: {
    home.packages = [ pkgs.localsend ];
  };

  config.flake.modules.nixos.localsend = { ... }: {
    networking.firewall.allowedTCPPorts = [ 53317 ];
    networking.firewall.allowedUDPPorts = [ 53317 ];
  };
}
