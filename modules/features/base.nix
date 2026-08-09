# Base system configuration.
# - darwin.base: primary user, nix daemon, fonts, shell (nix-darwin).
# - nixos.base: common NixOS baseline shared by all NixOS hosts (networking,
#   audio, containers, shell, nix settings/GC, fonts). Host-specific bits
#   (boot, hostname, user, stateVersion) live in modules/hosts/*.
# Folded in from the old inline `configuration` block in flake.nix.
{ ... }: {
  config.flake.modules.darwin.base = { pkgs, ... }: {
    system.primaryUser = "mingshiwang";
    fonts.packages = [
      pkgs.nerd-fonts.iosevka
      pkgs.sketchybar-app-font
    ];

    # Auto upgrade nix package and the daemon service.
    nix.enable = true;

    # Necessary for using flakes on this system.
    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];

    # Create /etc/zshrc that loads the nix-darwin environment.
    programs.zsh.enable = true; # default shell on catalina

    # Allow exactly copilot-language-server (unfree on Darwin) to evaluate.
    # NixOS global policy (allowUnfree) is unchanged.
    nixpkgs.config.allowUnfreePredicate = pkg: pkgs.lib.getName pkg == "copilot-language-server";
  };

  config.flake.modules.nixos.base = { pkgs, ... }: {
    # ─── Networking: NetworkManager ────────────────────────────────────────
    networking.networkmanager.enable = true;

    # ─── Audio: PipeWire + rtkit ───────────────────────────────────────────
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };

    # ─── Bluetooth: BlueZ ──────────────────────────────────────────────────
    # BlueZ provides the bluetoothd daemon / D-Bus API that Noctalia's
    # bluetooth widget reads. The Blueman GUI/applet is intentionally not
    # enabled — Noctalia (v5 recommended services) owns the bluetooth UI.
    hardware.bluetooth.enable = true;

    # ─── Containers: Docker ────────────────────────────────────────────────
    virtualisation.docker.enable = true;

    # ─── Shell: zsh as default login shell ─────────────────────────────────
    programs.zsh.enable = true;
    users.defaultUserShell = pkgs.zsh;

    # ─── Nix: secure, sensible settings + automatic GC ─────────────────────
    # NVIDIA proprietary drivers require allowing unfree packages.
    nixpkgs.config.allowUnfree = true;

    nix.settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = true;
      warn-dirty = false;
      # Only root and the wheel group may manage the daemon / substitute.
      trusted-users = [
        "root"
        "@wheel"
      ];
      allowed-users = [ "@wheel" ];
    };
    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    nix.optimise.automatic = true;

    # ─── Fonts ─────────────────────────────────────────────────────────────
    fonts.packages = with pkgs; [
      (nerd-fonts.iosevka)
      (nerd-fonts.fira-code)
      (nerd-fonts.jetbrains-mono)
    ];
  };
}
