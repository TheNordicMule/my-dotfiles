# System packages.
# - darwin.packages: installed via nix-darwin (the nixpkgs layer).
# - nixos.packages: NixOS environment.systemPackages (common utilities/dev
#   tools migrated from the Darwin set; darwin-only entries — colima,
#   anki-bin, bitwarden-desktop, wezterm as desktop app, … — are
#   handled by the home-manager profile instead).
{ ... }:
let
  # Packages installed on both platforms. This is exactly the set that used to
  # be duplicated between the darwin and nixos lists below; each platform set
  # is `shared` plus its own platform-specific entries.
  shared =
    { pkgs, ... }:
    with pkgs;
    [
      cmake
      gh
      go
      nix-search-tv
      nodejs
      # rust toolchain
      cargo
      rustc
      rustfmt
      # CLI utilities
      bandwhich
      bitwarden-cli
      btop
      coreutils
      delta
      dust
      fd
      jq
      lsd
      neovim
      nh
      procs
      tokei
      tree-sitter
      wget
      # terminal (Hyprland "$terminal" = wezterm; the HM module only deploys
      # .wezterm.lua — the package itself is installed here)
      wezterm
    ];
in
{
  config.flake.modules.darwin.packages = { pkgs, ... }: {
    environment.systemPackages =
      shared { inherit pkgs; }
      ++ (with pkgs; [
        # macOS-only desktop apps / dev tools
        anki-bin
        bitwarden-desktop
        colima
        docker
        luajit
        opam
        pom
      ]);
  };

  config.flake.modules.nixos.packages = { pkgs, ... }: {
    environment.systemPackages =
      shared { inherit pkgs; }
      ++ (with pkgs; [
        # NixOS-only dev tooling
        gnumake
        # CLI utilities
        docker-compose
        zip
        unzip
        # email client — default mailto/rfc822 handler (see thunderbird.nix)
        thunderbird
      ]);
  };
}
