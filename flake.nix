{
  description = "Mingshi's Darwin system flake (dendritic)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";
    import-tree.url = "github:vic/import-tree";
    firefox-addons.url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
    firefox-addons.inputs.nixpkgs.follows = "nixpkgs";
    # Catppuccin-mocha wallpaper collection (no flake.nix upstream). Pinned
    # deliberately at a fixed commit so a broad `nix flake update` cannot
    # advance the wallpaper source; update by bumping the rev in the URL, not
    # by relying on the lock alone. Exposed to Home Manager as
    # ~/Pictures/walls-catppuccin-mocha (see hyprland.nix).
    walls-catppuccin-mocha = {
      url = "github:orangci/walls-catppuccin-mocha/7bfdf10d16ad3a689f9f0cf3a0930da3d1a245a8";
      flake = false;
    };
    # Nord wallpaper collection (no flake.nix upstream). Pinned deliberately
    # at a fixed commit so a broad `nix flake update` cannot advance the
    # wallpaper source; update by bumping the rev in the URL, not by relying
    # on the lock alone. Exposed to Home Manager as ~/Pictures/walls-nordic
    # (see hyprland.nix).
    walls-nordic = {
      url = "github:linuxdotexe/nordic-wallpapers/7a8e3bcabafbefd1c5b19229841b9bf377a4b765";
      flake = false;
    };
  };

  # Thin root: every .nix file under ./modules is auto-imported as a
  # flake-parts module by import-tree. No manual imports list to maintain.
  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} (inputs.import-tree ./modules);
}
