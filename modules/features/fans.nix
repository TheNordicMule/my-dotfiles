# Fan/RGB monitoring and control for desktop towers.
# - lm-sensors: expose motherboard/CPU fan RPM + temps to the OS (the old
#   `hardware.sensors.lm-sensors` NixOS module was removed from nixpkgs;
#   install the package and load the Super-I/O chip module instead).
# - OpenRGB: GUI for reading/controlling case + CPU fan curves and RGB
#   (works with the Gigabyte board). The `services.hardware.openrgb` module
#   runs the SDK server as root and loads `i2c-dev` (and `i2c-piix4` for AMD)
#   automatically.
#
# After the rebuild, run `sudo sensors-detect` (answer yes) to identify the
# fan chip, then add its kernel module to `boot.kernelModules` here.
{...}: {
  config.flake.modules.nixos.fans = {pkgs, ...}: {
    services.hardware.openrgb = {
      enable = true;
      motherboard = "amd";
    };

    environment.systemPackages = with pkgs; [
      lm_sensors
    ];
  };
}
