# System packages.
# - darwin.packages: installed via nix-darwin (the nixpkgs layer).
# - nixos.packages: NixOS environment.systemPackages (common utilities/dev
#   tools migrated from the Darwin set; darwin-only entries — colima,
#   anki-bin, logseq, bitwarden-desktop, wezterm as desktop app, … — are
#   handled by the home-manager profile instead).
{...}: {
  config.flake.modules.darwin.packages = {pkgs, ...}: {
    environment.systemPackages = with pkgs;
      [
        alejandra
        anki-bin
        bandwhich
        bitwarden-cli
        bitwarden-desktop
        bottom
        btop
        cmake
        colima
        coreutils
        delta
        docker
        dust
        fd
        gh
        go
        jq
        lsd
        luajit
        neovim
        nodejs
        logseq
        opam
        # opencode
        pom
        procs
        tokei
        tree-sitter
        wezterm
        wget
      ]
      ++ [
        # rust related stuff
        cargo
        rust-analyzer
        rustc
        rustfmt
      ];
  };

  config.flake.modules.nixos.packages = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      # formatting / dev tooling
      alejandra
      cmake
      gnumake
      gcc
      git
      gh
      go
      nodejs
      python3
      # rust toolchain
      cargo
      rustc
      rustfmt
      rust-analyzer
      # CLI utilities
      bandwhich
      bitwarden-cli
      bottom
      btop
      coreutils
      delta
      docker-compose
      dust
      fd
      jq
      lsd
      neovim
      procs
      ripgrep
      tokei
      tree-sitter
      wget
      zip
      unzip
      # terminal (Hyprland "$terminal" = wezterm; the HM module only deploys
      # .wezterm.lua — the package itself is installed here)
      wezterm
      # hyprland ecosystem
      hyprpolkitagent
      uwsm
      xdg-desktop-portal-gtk
      # GUI
      gnome-system-monitor
      # email client — default mailto/rfc822 handler (see thunderbird.nix)
      thunderbird
    ];
  };
}
