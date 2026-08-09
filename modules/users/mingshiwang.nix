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
      hm.spotify-player
      hm.opencode
      hm.bins
      hm.firefox
      hm.vesktop
      hm.localsend
      # macOS-only: SketchyBar bar + AeroSpace window-manager configs. Imported
      # unconditionally because an HM `imports` list cannot branch on `pkgs`
      # (that recurses); their xdg.configFile entries are disabled on Linux by
      # the platform module below.
      hm.sketchybar
      hm.static-configs
      # Platform-dependent values + the Linux-only Hyprland import. Lives in an
      # imported module (not directly in this attrset) so it can take `pkgs`
      # and `osConfig` as module arguments.
      ({
        pkgs,
        osConfig,
        lib,
        ...
      }: let
        isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
      in {
        # Hyprland, Thunderbird and Swayimg are Linux-only (NixOS) modules. `imports`
        # cannot depend on config-derived args like `pkgs` (that recurses), but
        # `osConfig` — the OS config — is passed as an external module argument,
        # so branching on it here is safe and evaluates lazily (the modules are
        # only forced when actually imported). `system.defaults` is a
        # nix-darwin-only option, so its presence means this is a macOS host.
        imports = lib.optionals (!(osConfig.system or {}) ? defaults) [hm.hyprland hm.thunderbird hm.swayimg];
        # mkForce: home-manager's darwin common module derives homeDirectory
        # from `users.users.<name>.home`, which is null on nix-darwin (existing
        # macOS users aren't declared in `users.users`). Override that
        # derivation rather than declaring the user (which would trigger
        # nix-darwin user management). On Linux the Home Manager default is
        # /home/mingshiwang; keep it explicit.
        home.homeDirectory = lib.mkForce (
          if isDarwin
          then "/Users/mingshiwang"
          else "/home/mingshiwang"
        );
        # Homebrew lives under /opt/homebrew only on Apple Silicon macOS.
        home.sessionPath = (lib.optionals isDarwin ["/opt/homebrew/bin"]) ++ ["$HOME/bin"];
        # macOS-only deployments from sketchybar.nix / static-configs.nix are
        # disabled on Linux (see the imports note above).
        xdg.configFile."sketchybar" = lib.mkIf (!isDarwin) {enable = lib.mkForce false;};
        xdg.configFile."aerospace" = lib.mkIf (!isDarwin) {enable = lib.mkForce false;};
      })
    ];

    home.username = "mingshiwang";
    home.stateVersion = "26.11";
    xdg.enable = true;

    home.sessionVariables = {
      EDITOR = "nvim";
      OPENCODE_EXPERIMENTAL_BACKGROUND_SUBAGENTS = "true";
    };
  };
}
