# Swayimg — lightweight Wayland image viewer.
# Installed via home.packages and registered as the default handler for
# common image MIME types through xdg.mimeApps (defaultApplications only;
# xdg.mimeApps.enable is owned elsewhere). Linux-only: the user module
# imports it conditionally (see mingshiwang.nix).
{ ... }: {
  config.flake.modules.homeManager.swayimg = { pkgs, ... }: {
    home.packages = [ pkgs.swayimg ];

    xdg.mimeApps.defaultApplications = {
      "image/png" = [ "swayimg.desktop" ];
      "image/jpeg" = [ "swayimg.desktop" ];
      "image/gif" = [ "swayimg.desktop" ];
      "image/webp" = [ "swayimg.desktop" ];
      "image/bmp" = [ "swayimg.desktop" ];
      "image/tiff" = [ "swayimg.desktop" ];
      "image/avif" = [ "swayimg.desktop" ];
      "image/svg+xml" = [ "swayimg.desktop" ];
    };
  };
}
