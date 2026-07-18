# Darwin system settings — platform, touch-id, keyboard remaps, dock, menu bar.
# `self` is captured from the flake-parts scope (no specialArgs needed).
{self, ...}: {
  config.flake.modules.darwin.system = {
    # The platform the configuration will be used on.
    nixpkgs.hostPlatform = "aarch64-darwin";
    # enable touch id for sudo
    security.pam.services.sudo_local.touchIdAuth = true;
    security.pam.services.sudo_local.watchIdAuth = true;
    system.configurationRevision = self.rev or self.dirtyRev or null;

    system.keyboard = {
      enableKeyMapping = true;
      remapCapsLockToEscape = true;
    };

    # Used for backwards compatibility, please read the changelog before changing.
    # $ darwin-rebuild changelog
    system.stateVersion = 7;

    # nix-darwin default is 350; we use 30000 to match the builder group GID on
    # the remote macOS builders, keeping builds portable.
    ids.gids.nixbld = 30000;

    system.defaults.WindowManager = {
      StandardHideWidgets = true;
    };
    system.defaults.dock = {
      autohide = true;
      # disable rearrange workspace based on MRU algo
      mru-spaces = false;
      orientation = "left";
      # show only open apps
      static-only = true;

      # aerospace perfers
      expose-group-apps = true;
    };

    # make space for sketchybar
    system.defaults.NSGlobalDomain._HIHideMenuBar = true;
  };
}
