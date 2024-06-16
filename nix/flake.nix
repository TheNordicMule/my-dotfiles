{
  description = "Example Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs @ {
    self,
    nix-darwin,
    nixpkgs,
  }: let
    configuration = {pkgs, ...}: {
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
    };
  in {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#Mac-that-vim
    darwinConfigurations."Mac-that-vim" = nix-darwin.lib.darwinSystem {
      specialArgs = self;
      modules = [configuration ./modules/apps.nix ./modules/system.nix];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."Mac-that-vim".pkgs;
  };
}
