# NixOS host assembly — composes the class-keyed NixOS feature modules
# (flake.modules.nixos.*) plus the same home-manager wiring used by
# hosts/mac-that-vim.nix into a single nixosConfiguration.
#
# Host-specific settings only live here (UEFI boot, hardware-config path
# logic/assertion, hostname, user, stateVersion); everything generic is in
# modules/features/ under flake.modules.nixos.{base,packages,nvidia,hyprland,steam,fans,printing}.
#
# The root filesystem and /boot are declared by Disko (nixos/disko.nix,
# imported below), so the generated, gitignored
# nixos/hardware-configuration.nix is mandatory only for generated hardware
# settings (kernel modules, microcode, etc.), NOT for filesystems. It is
# produced on the target with `nixos-generate-config --no-filesystems
# --show-hardware-config --root /mnt >
# <repo>/nixos/hardware-configuration.nix` (--no-filesystems is essential:
# Disko owns fileSystems/swapDevices) and never staged/committed (see
# .gitignore).
# Because it is untracked/ignored, git+file flake refs (`.#…`) would silently
# hide it, so every installer/rebuild command uses an explicit `path:` flake
# ref (path:/mnt/…/my-dotfiles#nixos-desktop, or path:. from inside the repo),
# which copies the working directory verbatim including ignored files. Until
# the file exists, evaluating the target's `system.build.toplevel` fails with
# a clear assertion below — there is no silent fallback hardware config.
# `nix flake show` over a path: ref still works before install; for a
# deliberate pre-install dry-run, copy nixos/hardware-configuration.nix.example
# → nixos/hardware-configuration.nix.
#
# Build with:
#   nh os switch path:. -H nixos-desktop
# (`nh` self-elevates internally; `path:.` keeps the gitignored
# hardware-configuration.nix visible — a git ref would hide it.)
{
  inputs,
  config,
  lib,
  ...
}:
let
  nixos = config.flake.modules.nixos;
  hm = config.flake.modules.homeManager;
  hardware-configuration = ../../nixos/hardware-configuration.nix;
  disko-configuration = ../../nixos/disko.nix;
in
{
  config.flake.nixosConfigurations.nixos-desktop = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      # Common NixOS baseline + feature modules (dendritic, class-keyed).
      nixos.base
      nixos.packages
      nixos.nvidia
      nixos.hyprland
      nixos.steam
      nixos.fans
      nixos.printing
      nixos.localsend

      # Disko declares the disk layout (root filesystem + /boot, mounted by
      # Disko); see nixos/disko.nix.
      inputs.disko.nixosModules.disko
      disko-configuration

      inputs.home-manager.nixosModules.home-manager
      {
        # Same Home Manager wiring as modules/hosts/mac-that-vim.nix.
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.backupFileExtension = "backup";
        home-manager.extraSpecialArgs = {
          inherit (inputs)
            firefox-addons
            walls-catppuccin-mocha
            walls-nordic
            ;
        };
        home-manager.users.mingshiwang = {
          imports = [
            hm.mingshiwang
            hm.noctalia
          ];
        };
      }

      # ─── Host-specific settings (proper NixOS module: pkgs/config resolve
      # from the NixOS module system, not flake-parts) ─────────────────────
      (
        {
          config,
          pkgs,
          ...
        }:
        {
          # Clean UEFI systemd-boot install.
          boot.loader.systemd-boot.enable = true;
          boot.loader.efi.canTouchEfiVariables = true;

          networking.hostName = "nixos-desktop";

          time.timeZone = "America/Chicago";

          # Normal wheel/networkmanager/docker user. No plaintext password in
          # the flake: set one at install time (`passwd mingshiwang`), see
          # nixos/README.md.
          users.users.mingshiwang = {
            isNormalUser = true;
            description = "Mingshi Wang";
            shell = pkgs.zsh;
            extraGroups = [
              "wheel"
              "networkmanager"
              "docker"
              "i2c"
            ];
          };

          # Require the generated, gitignored hardware config. Disko
          # (nixos/disko.nix, imported above) supplies the root filesystem and
          # /boot, so this file is mandatory only for generated hardware
          # settings (kernel modules, microcode). Failing here is intentional:
          # without it we would silently evaluate without hardware detection.
          # Generate it on the target with `nixos-generate-config
          # --no-filesystems --show-hardware-config --root /mnt >
          # <repo>/nixos/hardware-configuration.nix` and never commit it. For
          # a pre-install dry-run, copy
          # nixos/hardware-configuration.nix.example →
          # nixos/hardware-configuration.nix (see nixos/README.md).
          assertions = [
            {
              assertion = builtins.pathExists hardware-configuration;
              message = ''
                Missing hardware configuration: nixos/hardware-configuration.nix is not present.
                Generate it on the target with
                `nixos-generate-config --no-filesystems --show-hardware-config --root /mnt >
                <repo>/nixos/hardware-configuration.nix` (--no-filesystems because Disko
                declares fileSystems/swapDevices) and use a `path:` flake ref (e.g.
                `nh os switch path:. -H nixos-desktop`) so the untracked, gitignored file is
                visible — never commit it. See nixos/README.md.
                For a pre-install dry-run, copy nixos/hardware-configuration.nix.example
                to nixos/hardware-configuration.nix.
              '';
            }
          ];

          # This value determines the NixOS release from which this config is
          # meant to be installed; change it only by bumping stateVersion on a
          # fresh install.
          system.stateVersion = "26.05";
        }
      )
    ]
    # Import the generated, gitignored hardware config only once it exists
    # (callers must use a `path:` flake ref so it is visible — see header);
    # the assertion above fails loudly if the target is built without it. It
    # contributes generated hardware settings only — Disko already declared
    # the filesystems.
    ++ lib.optionals (builtins.pathExists hardware-configuration) [ hardware-configuration ];
  };
}
