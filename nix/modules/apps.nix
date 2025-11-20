{pkgs, ...}: {
  environment.systemPackages = with pkgs;
    [
      alejandra
      anki-bin
      bandwhich
      bat
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
      fzf
      gh
      gh-copilot
      go
      jq
      lsd
      luajit
      neovim
      nodejs
      obsidian
      opam
      opencode
      pom
      ripgrep
      spotify
      starship
      stow
      tealdeer
      tmux
      tokei
      vscode
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
      "nikitabobko/tap"
      "FelixKratz/formulae"
    ];

    brews = [
      "sketchybar"
    ];

    casks = [
      "aerospace"
      "font-sf-pro"
      "raycast"
      "sf-symbols"
      "stats"
      "wechat"
    ];
  };
}
