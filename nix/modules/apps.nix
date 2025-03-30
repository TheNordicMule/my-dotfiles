{pkgs, ...}: {
  environment.systemPackages = with pkgs;
    [
      alejandra
      bat
      bottom
      cmake
      coreutils
      delta
      dust
      fd
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
    };

    taps = [
      "homebrew/bundle"
      "homebrew/cask-drivers"
      "homebrew/cask-fonts"
      "homebrew/cask-versions"
      "homebrew/services"
      "nikitabobko/tap"
    ];

    casks = [
      "aerospace"
      "anki"
      "bitwarden"
      "discord"
      "docker"
      "firefox"
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
