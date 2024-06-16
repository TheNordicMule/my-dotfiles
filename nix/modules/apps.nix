{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    pom
    alejandra
    dust
    bat
    bottom
    cmake
    coreutils
    fd
    fzf
    gh
    delta
    go
    jq
    lsd
    luajit
    neovim
    nodejs
    ripgrep
    starship
    stow
    tealdeer
    tmux
    tokei
    wget
    alacritty
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
    ];

    casks = [
      "aldente"
      "amethyst"
      "anki"
      "bitwarden"
      "discord"
      "firefox"
      "font-sauce-code-pro-nerd-font"
      "font-sf-pro"
      "kindle"
      "obsidian"
      "raycast"
      "sf-symbols"
      "spotify"
      "stats"
      "visual-studio-code"
      "vlc"
      "wechat"
    ];
  };
}
