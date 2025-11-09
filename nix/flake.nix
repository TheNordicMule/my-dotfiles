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
      system.primaryUser = "mingshiwang";
      nixpkgs.config.allowUnfree = true;
      fonts.packages = [
        pkgs.iosevka
        pkgs.sketchybar-app-font
      ];

      # Auto upgrade nix package and the daemon service.
      nix.enable = true;
      # nix.package = pkgs.nix;

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Create /etc/zshrc that loads the nix-darwin environment.
      programs.zsh.enable = true; # default shell on catalina
    };
  in {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#Mac-that-vim
    darwinConfigurations."Mac-that-vim" = nix-darwin.lib.darwinSystem {
      modules = [configuration ./modules/apps.nix ./modules/system.nix];
      specialArgs = {inherit self;};
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."Mac-that-vim".pkgs;
  };
}
