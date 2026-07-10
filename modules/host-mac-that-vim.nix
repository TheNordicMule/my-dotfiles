# Host assembly — gathers the darwin + home-manager feature modules produced
# by every file under modules/features/ and wires them into a single
# darwinConfiguration.
#
# Build with:
#   darwin-rebuild switch --flake .#Mac-that-vim
{inputs, config, ...}: let
  darwin = config.flake.modules.darwin;
  hm = config.flake.modules.homeManager;
in {
  config.flake.darwinConfigurations."Mac-that-vim" = inputs.nix-darwin.lib.darwinSystem {
    modules = [
      darwin.base
      darwin.system
      darwin.packages
      darwin.homebrew
      inputs.home-manager.darwinModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.backupFileExtension = "backup";
        home-manager.users.mingshiwang = hm.mingshiwang;
      }
    ];
  };

  # Expose the package set, including overlays, for convenience.
  config.flake.darwinPackages = config.flake.darwinConfigurations."Mac-that-vim".pkgs;
}
