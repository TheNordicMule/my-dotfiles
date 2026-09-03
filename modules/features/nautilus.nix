# Nautilus — GNOME file manager.
# Installed via home.packages and registered as the default file manager
# through xdg.mimeApps (inode/directory). Linux-only: the user module
# imports it conditionally (see mingshiwang.nix).
{ ... }: {
  config.flake.modules.homeManager.nautilus = { pkgs, ... }: {
    home.packages = [ pkgs.nautilus ];

    xdg.mimeApps.defaultApplications = {
      "inode/directory" = [ "org.gnome.Nautilus.desktop" ];
    };
  };
}
