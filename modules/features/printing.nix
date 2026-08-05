# Driverless printing for NixOS hosts.
# - CUPS: the printing service. IPP Everywhere / AirPrint printers speak the
#   driverless IPP protocol natively, so no vendor/model-specific drivers or
#   static queues are needed — add any queues at runtime via
#   system-config-printer.
# - Avahi: mDNS/DNS-SD so CUPS auto-discovers network printers, with the mDNS
#   NSS module so `.local` hostnames resolve and the firewall opened for mDNS
#   (UDP 5353).
# - ipp-usb: exposes IPP-capable USB printers/scanners (AirPrint/AirScan) as
#   local IPP endpoints so CUPS sees them without a USB backend.
# - system-config-printer: GTK GUI to add/manage printers and queues.
{...}: {
  config.flake.modules.nixos.printing = {pkgs, ...}: {
    # CUPS printing service (driverless/IPP Everywhere baseline).
    services.printing.enable = true;

    # Avahi mDNS/DNS-SD for automatic network-printer discovery.
    services.avahi.enable = true;
    # Resolve `.local` hostnames of discovered printers via NSS (IPv4).
    services.avahi.nssmdns4 = true;
    # Open the firewall for mDNS (UDP 5353).
    services.avahi.openFirewall = true;

    # IPP-over-USB: turn IPP-capable USB printers into local IPP endpoints.
    services.ipp-usb.enable = true;

    environment.systemPackages = with pkgs; [
      # GUI for adding/managing printers and print queues.
      system-config-printer
    ];
  };
}
