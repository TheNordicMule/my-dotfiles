# Fan monitoring for desktop towers.
# - lm-sensors: expose motherboard/CPU fan RPM + temps to the OS (the old
#   `hardware.sensors.lm-sensors` NixOS module was removed from nixpkgs;
#   install the package and load the Super-I/O chip module instead).
# - xsensors: GUI dashboard for detected temperatures and fan RPM.
#
# After the rebuild, run `sudo sensors-detect` (answer yes) to identify the
# fan chip, then add its kernel module to `boot.kernelModules` here.
{...}: {
  config.flake.modules.nixos.fans = {
    config,
    pkgs,
    ...
  }: {
    # The B650 GAMING X AX V2 uses an ITE IT8689E fan controller. Nixpkgs's
    # packaged upstream it87 driver supports its newer access method; scope
    # the ACPI-resource override to that driver instead of relaxing ACPI
    # resource checks globally.
    boot.extraModulePackages = [config.boot.kernelPackages.it87];
    boot.kernelModules = ["it87"];
    boot.extraModprobeConfig = ''
      options it87 ignore_resource_conflict=1
    '';

    environment.systemPackages = with pkgs; [
      lm_sensors
      xsensors
    ];
  };
}
