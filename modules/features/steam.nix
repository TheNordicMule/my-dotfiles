# Steam on NixOS.
# `programs.steam` wires up everything Steam needs on NixOS (32-bit libs,
# hardware acceleration, gamepad support, SteamOS-like defaults), so prefer
# it over a bare `steam` in environment.systemPackages.
{ ... }: {
  config.flake.modules.nixos.steam = { ... }: {
    programs.steam.enable = true;
  };
}
