{pkgs, ...}: {
  environment.systemPackages = with pkgs;
    [
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

  # you still need to install brew manually
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = false;
      cleanup = "zap";
    };

    taps = [
      "homebrew/bundle"
      "homebrew/cask-drivers"
      "homebrew/cask-fonts"
      "homebrew/cask-versions"
      "homebrew/services"
      {
        name = "nikitabobko/tap";
        trusted = true;
      }
      {
        name = "felixkratz/formulae";
        trusted = true;
      }
      "anomalyco/tap"
    ];

    brews = [
      "sketchybar"
      "opencode"
    ];

    casks = [
      "aerospace"
      "canon-ufrii-driver"
      "font-sf-pro"
      "raycast"
      "sf-symbols"
      "spotify"
      "stats"
      "wechat"
    ];
  };
}
