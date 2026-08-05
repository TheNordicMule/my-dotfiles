# Thunderbird — email client.
# Installed via NixOS systemPackages (see packages.nix); this HM feature
# registers it as the default handler for mailto: links and message/rfc822
# email files through xdg.mimeApps. Linux-only: the user module imports it
# conditionally (see mingshiwang.nix).
{...}: {
  config.flake.modules.homeManager.thunderbird = {...}: {
    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "x-scheme-handler/mailto" = ["thunderbird.desktop"];
        "message/rfc822" = ["thunderbird.desktop"];
      };
    };
  };
}
