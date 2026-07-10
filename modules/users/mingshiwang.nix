# User home-manager base — owns the home.username/homeDirectory/stateVersion
# and selects which HM feature modules this user gets via `imports`.
{
  config,
  lib,
  ...
}: let
  hm = config.flake.modules.homeManager;
in {
  config.flake.modules.homeManager.mingshiwang = {
    imports = [
      hm.theme-runtime
      hm.git
      hm.zsh
      hm.fzf
      hm.bat
      hm.ripgrep
      hm.tealdeer
      hm.starship
      hm.wezterm
      hm.nvim
      hm.sketchybar
      hm.opencode
      hm.static-configs
      hm.bins
      hm.firefox # policies only — browser installed via Homebrew cask
    ];

    home.username = "mingshiwang";
    # mkForce: home-manager's darwin common module derives this from
    # `users.users.<name>.home`, which is null on nix-darwin (existing macOS
    # users aren't declared in `users.users`). Override that derivation rather
    # than declaring the user (which would trigger nix-darwin user management).
    home.homeDirectory = lib.mkForce "/Users/mingshiwang";
    home.stateVersion = "26.11";
    xdg.enable = true;

    home.sessionVariables = {
      EDITOR = "nvim";
      OPENCODE_EXPERIMENTAL_BACKGROUND_SUBAGENTS = "true";
    };

    home.sessionPath = [
      "/opt/homebrew/bin"
      "$HOME/bin"
    ];
  };
}
