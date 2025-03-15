{self, ...}: {
  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
  # enable touch id for sudo
  security.pam.services.sudo_local.touchIdAuth = true;
  system.configurationRevision = self.rev or self.dirtyRev or null;

  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToEscape = true;
    swapLeftCommandAndLeftAlt = true;
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

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
}
