# Fan monitoring for desktop towers.
# - lm-sensors: expose motherboard/CPU fan RPM + temps to the OS (the old
#   `hardware.sensors.lm-sensors` NixOS module was removed from nixpkgs;
#   install the package and load the Super-I/O chip module instead).
# - xsensors: GUI dashboard for detected temperatures and fan RPM.
#
# After the rebuild, run `sudo sensors-detect` (answer yes) to identify the
# fan chip, then add its kernel module to `boot.kernelModules` here.
{...}: {
  config.flake.modules.nixos.fans = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      lm_sensors
      xsensors
    ];
  };
}
