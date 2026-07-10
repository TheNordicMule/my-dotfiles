# System packages installed via nix-darwin (the nixpkgs layer).
{...}: {
  config.flake.modules.darwin.packages = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      alejandra
      anki-bin
      bandwhich
      bitwarden-cli
      bitwarden-desktop
      bottom
      cmake
      colima
      coreutils
      delta
      discord
      docker
      dust
      fd
      firefox-unwrapped
      gh
      github-copilot-cli
      go
      jq
      lsd
      luajit
      neovim
      nodejs
      obsidian
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
}
