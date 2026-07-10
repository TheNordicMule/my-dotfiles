# Base darwin system configuration — primary user, nix daemon, fonts, shell.
# Folded in from the old inline `configuration` block in flake.nix plus the
# electron permittedInsecurePackages inline module.
{...}: {
  config.flake.modules.darwin.base = {pkgs, ...}: {
    system.primaryUser = "mingshiwang";
    nixpkgs.config.allowUnfree = true;
    nixpkgs.config.permittedInsecurePackages = [
      "electron-39.8.10"
    ];
    fonts.packages = [
      pkgs.nerd-fonts.iosevka
      pkgs.sketchybar-app-font
    ];

    # Auto upgrade nix package and the daemon service.
    nix.enable = true;

    # TODO: remove
    documentation.enable = false;
    system.tools.darwin-uninstaller.enable = false;

    # Necessary for using flakes on this system.
    nix.settings.experimental-features = ["nix-command" "flakes"];

    # Create /etc/zshrc that loads the nix-darwin environment.
    programs.zsh.enable = true; # default shell on catalina
  };
}
