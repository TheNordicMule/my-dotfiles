{pkgs, ...}: {
  environment.systemPackages = with pkgs;
    [
      alejandra
      bandwhich
      bat
      bitwarden-desktop
      bottom
      cmake
      colima
      coreutils
      delta
      docker
      dust
      fd
      firefox-unwrapped
      fzf
      gh
      go
      jq
      lsd
      luajit
      neovim
      nodejs
      opam
      pom
      ripgrep
      starship
      stow
      tealdeer
      tmux
      tokei
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
      "anki"
      "discord"
      "font-sf-pro"
      "obsidian"
      "raycast"
      "sf-symbols"
      "spotify"
      "stats"
      "visual-studio-code"
      "wechat"
    ];
  };
}
