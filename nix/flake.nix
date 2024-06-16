{
  description = "Example Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-24.05-darwin";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs @ {
    self,
    nix-darwin,
    nixpkgs,
  }: let
    configuration = {pkgs, ...}: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages = [
        pkgs.pom
        pkgs.alejandra
        pkgs.dust
        pkgs.bat
        pkgs.bottom
        pkgs.cmake
        pkgs.coreutils
        pkgs.fd
        pkgs.fzf
        pkgs.gh
        pkgs.delta
        pkgs.go
        pkgs.jq
        pkgs.lsd
        pkgs.luajit
        pkgs.neovim
        pkgs.nodejs
        pkgs.ripgrep
        pkgs.starship
        pkgs.stow
        pkgs.tealdeer
        pkgs.tmux
        pkgs.tokei
        pkgs.wget
      ];

      services.sketchybar.enable = true;

      fonts.fonts = [
        pkgs.sketchybar-app-font
      ];
      fonts.fontDir.enable = true;

      # Auto upgrade nix package and the daemon service.
      services.nix-daemon.enable = true;
      # nix.package = pkgs.nix;

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Create /etc/zshrc that loads the nix-darwin environment.
      programs.zsh.enable = true; # default shell on catalina

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 4;

      system.defaults.dock.autohide = true;
      # disable rearrange workspace based on MRU algo
      system.defaults.dock.mru-spaces = false;
      # hide the menu bar for sketchybar
      system.defaults.NSGlobalDomain._HIHideMenuBar = true;
      # enable touch id for sudo
      security.pam.enableSudoTouchIdAuth = true;

      system.keyboard = {
        enableKeyMapping = true;
        remapCapsLockToEscape = true;
        swapLeftCommandAndLeftAlt = true;
      };

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  in {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#Mac-that-vim
    darwinConfigurations."Mac-that-vim" = nix-darwin.lib.darwinSystem {
      modules = [configuration];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."Mac-that-vim".pkgs;
  };
}
