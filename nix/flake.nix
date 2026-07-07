{
  description = "Example Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs @ {
    self,
    nix-darwin,
    nixpkgs,
    home-manager,
  }: let
    configuration = {pkgs, ...}: {
      system.primaryUser = "mingshiwang";
      nixpkgs.config.allowUnfree = true;
      fonts.packages = [
        pkgs.nerd-fonts.iosevka
        pkgs.sketchybar-app-font
      ];

      # Auto upgrade nix package and the daemon service.
      nix.enable = true;

      # TODO: remove
      documentation.enable = false;
      system.tools.darwin-uninstaller.enable = false;

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Create /etc/zshrc that loads the nix-darwin environment.
      programs.zsh.enable = true; # default shell on catalina

      # Required for oh-my-zsh and zsh-syntax-highlighting to appear in /run/current-system/sw
      environment.pathsToLink = [
        "/share/oh-my-zsh"
        "/share/zsh-syntax-highlighting"
      ];
    };
  in {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#Mac-that-vim
    darwinConfigurations."Mac-that-vim" = nix-darwin.lib.darwinSystem {
      modules = [
        # TODO: remove this
        {
          nixpkgs.config.permittedInsecurePackages = [
            "electron-39.8.10"
          ];
        }
        configuration
        ./modules/apps.nix
        ./modules/system.nix
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.mingshiwang = import ./modules/home.nix;
        }
      ];
      specialArgs = {inherit self;};
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."Mac-that-vim".pkgs;
  };
}
