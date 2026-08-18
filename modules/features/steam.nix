# Gaming on NixOS.
# `programs.steam` wires up everything Steam needs on NixOS (32-bit libs,
# hardware acceleration, gamepad support, SteamOS-like defaults), so prefer
# it over a bare `steam` in environment.systemPackages. Lutris provides the
# Battle.net installer and launcher required by StarCraft II.
{ ... }: {
  config.flake.modules.nixos.steam = { pkgs, ... }: {
    programs.steam.enable = true;
    environment.systemPackages = with pkgs; [
      lutris
      gamescope
    ];
  };
}
