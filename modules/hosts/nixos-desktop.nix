# NixOS host assembly — composes the class-keyed NixOS feature modules
# (flake.modules.nixos.*) plus the same home-manager wiring used by
# hosts/mac-that-vim.nix into a single nixosConfiguration.
#
# Host-specific settings only live here (UEFI boot, hardware-config path
# logic/assertion, hostname, user, stateVersion); everything generic is in
# modules/features/ under flake.modules.nixos.{base,packages,nvidia,hyprland}.
#
# nixos/hardware-configuration.nix is a generated, local, IGNORED per-machine
# file (see .gitignore): produced on the target by `nixos-generate-config
# --root /mnt --dir <repo>/nixos` and never staged/committed. Because it is
# untracked/ignored, git+file flake refs (`.#…`) would silently hide it, so
# every installer/rebuild command uses an explicit `path:` flake ref
# (path:/mnt/…/my-dotfiles#nixos-desktop, or path:. from inside the repo),
# which copies the working directory verbatim including ignored files. Until
# the file exists, evaluating the target's `system.build.toplevel` fails with
# a clear assertion below — there is no silent placeholder root filesystem.
# `nix flake show` over a path: ref still works before install; for a
# deliberate pre-install dry-run, copy nixos/hardware-configuration.nix.example
# → nixos/hardware-configuration.nix.
#
# Build with:
#   sudo nixos-rebuild switch --flake path:.#nixos-desktop
{
  inputs,
  config,
  lib,
  ...
}: let
  nixos = config.flake.modules.nixos;
  hm = config.flake.modules.homeManager;
  hardware-configuration = ../../nixos/hardware-configuration.nix;
in {
  config.flake.nixosConfigurations.nixos-desktop = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules =
      [
        # Common NixOS baseline + feature modules (dendritic, class-keyed).
        nixos.base
        nixos.packages
        nixos.nvidia
        nixos.hyprland
        nixos.steam
        nixos.fans

        inputs.home-manager.nixosModules.home-manager
        {
          # Same home-manager wiring as modules/hosts/mac-that-vim.nix.
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "backup";
          home-manager.extraSpecialArgs = {inherit (inputs) firefox-addons walls-catppuccin-mocha;};
          home-manager.users.mingshiwang = hm.mingshiwang;
        }

        # ─── Host-specific settings (proper NixOS module: pkgs/config resolve
        # from the NixOS module system, not flake-parts) ─────────────────────
        ({
          config,
          pkgs,
          ...
        }: {
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
            extraGroups = ["wheel" "networkmanager" "docker"];
          };

          # Require a real root filesystem. The generated, gitignored
          # nixos/hardware-configuration.nix defines fileSystems (and is
          # imported below once present via a `path:` flake ref). Failing here
          # is intentional: without it we would silently evaluate against a
          # bogus disk layout. For a pre-install dry-run, copy
          # nixos/hardware-configuration.nix.example →
          # nixos/hardware-configuration.nix (see nixos/README.md).
          assertions = [
            {
              assertion = config.fileSystems ? "/";
              message = ''
                Missing root filesystem: nixos/hardware-configuration.nix is not present.
                Generate it on the target with
                `nixos-generate-config --root /mnt --dir <repo>/nixos` and use a `path:` flake
                ref (e.g. `nixos-rebuild switch --flake path:.#nixos-desktop`) so the
                untracked, gitignored file is visible — never `git add` it. See nixos/README.md.
                For a pre-install dry-run, copy nixos/hardware-configuration.nix.example
                to nixos/hardware-configuration.nix.
              '';
            }
          ];

          # This value determines the NixOS release from which this config is
          # meant to be installed; change it only by bumping stateVersion on a
          # fresh install.
          system.stateVersion = "26.05";
        })
      ]
      # Import the generated, gitignored hardware config only once it exists
      # (callers must use a `path:` flake ref so it is visible — see header);
      # the assertion above fails loudly if the target is built without it.
      ++ lib.optionals (builtins.pathExists hardware-configuration) [hardware-configuration];
  };
}
