# NVIDIA GPU configuration for NixOS hosts.
# RTX 20-series or newer → open kernel module + modesetting; single-GPU desktop
# so no PRIME offloading is configured.
{...}: {
  config.flake.modules.nixos.nvidia = {config, ...}: {
    services.xserver.videoDrivers = ["nvidia"];
    hardware.graphics.enable = true;
    hardware.nvidia = {
      open = true;
      modesetting.enable = true;
      # Explicitly pin the stable driver channel.
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
  };
}
