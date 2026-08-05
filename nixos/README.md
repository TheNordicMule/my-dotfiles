# NixOS `nixos-desktop` host

x86_64-linux desktop host: UEFI + systemd-boot, NetworkManager, PipeWire,
Docker, zsh, NVIDIA (open kernel modules, RTX 20-series or newer), Bluetooth
(BlueZ + Blueman), fan monitoring, Steam, Hyprland under UWSM, greetd +
tuigreet login, and home-manager wired exactly like the Darwin host
(`modules/hosts/mac-that-vim.nix`).

The host is assembled in `modules/hosts/nixos-desktop.nix`; the system
configuration lives in class-keyed feature modules under `modules/features/`
(`flake.modules.nixos.{base,packages,nvidia,hyprland,steam,fans}`).

## Hardware config policy

`nixos/hardware-configuration.nix` is a **generated, local, ignored
per-machine file**:

- It is produced on the target by `nixos-generate-config` (see below) and is
  listed in `.gitignore` — it is **never staged or committed**.
- Because it is untracked/ignored, `git+file` flake refs (`.`, `.#…`) would
  silently hide it. **Every installer/rebuild command that must see it uses an
  explicit `path:` flake reference** (`path:/mnt/home/…/my-dotfiles`, or
  `path:.` from inside the repo), which copies the working directory verbatim
  including ignored files.
- No Windows or disk layout is baked into the Nix files. The NixOS
  configuration **requires** that file: there is no silent placeholder root
  filesystem, so evaluating the target without it fails with a clear assertion.

## Installer overview

### 1. Boot the NixOS installer and partition

Boot the NixOS **unstable** minimal ISO (must match the flake's
`nixpkgs-unstable`). For a clean single-OS UEFI install:

```bash
# Example: GPT + systemd-boot, swap optional. Adjust to your disks.
lsblk
sudo -i
gdisk /dev/nvme0n1        # create a 1G EFI partition (ef00) + a root partition
mkfs.fat -F32 /dev/nvme0n1p1
mkfs.ext4 /dev/nvme0n1p2
```

### 2. Mount, clone the repo, and generate the hardware config

```bash
mount /dev/nvme0n1p2 /mnt
mkdir -p /mnt/boot
mount /dev/nvme0n1p1 /mnt/boot
# swap (optional):
# mkswap /dev/nvme0n1p3 && swapon /dev/nvme0n1p3

# Create the target user's home before cloning — the repo must live there so
# the absolute out-of-store config links (config/nvim, config/opencode, …)
# resolve after first boot:
mkdir -p /mnt/home/mingshiwang
git clone https://github.com/TheNordicMule/my-dotfiles /mnt/home/mingshiwang/my-dotfiles
# (or copy the repo from the booted installer: cp -r /path/to/my-dotfiles /mnt/home/mingshiwang/)

# Generate the hardware config directly into the persistent repo. It is a
# generated, local, gitignored per-machine file — never stage or commit it:
nixos-generate-config --root /mnt --dir /mnt/home/mingshiwang/my-dotfiles/nixos
```

`modules/hosts/nixos-desktop.nix` imports `nixos/hardware-configuration.nix`
once it is present. Before it is, only lazy evaluations (`nix flake show` over
a `path:` ref) work; forcing the target build fails with an assertion pointing
here.

### 3. Install, then set the password

The `mingshiwang` user is defined as a normal `wheel`/`networkmanager`/`docker`
user with **no plaintext password** in the flake. Install first, then set the
password inside the installed system:

```bash
# Build for the target from the repo. `path:` (not `.`) so Nix sees the
# untracked, gitignored hardware config — do NOT git add it:
nixos-install --flake path:/mnt/home/mingshiwang/my-dotfiles#nixos-desktop

# Set the user password in the installed system (nixos-enter needs a working
# system, so this runs AFTER nixos-install):
nixos-enter --root /mnt -c 'passwd mingshiwang'

# Fix ownership of the repo so the user can edit it after boot (nvim's
# lazy.lock.json, opencode's node_modules, etc. need write access):
nixos-enter --root /mnt -c 'chown -R mingshiwang:users /home/mingshiwang/my-dotfiles'
```

> Without the `passwd` step you cannot log in at the greetd screen.

### 4. Reboot

```bash
cd /
umount -R /mnt
reboot
```

After first boot, day-to-day switches use the same flake from the repo home.
Again use `path:.` so the untracked, gitignored hardware config stays visible:

```bash
cd ~/my-dotfiles
sudo nixos-rebuild switch --flake path:.#nixos-desktop
```

## Notes

- **Hardware config is mandatory** — evaluating the target without
  `nixos/hardware-configuration.nix` fails loudly (assertion in
  `modules/hosts/nixos-desktop.nix`). There is no silent fallback layout.
- **Use `path:` flake refs for anything that must see the hardware config** —
  `nixos-install`/`nixos-rebuild` with `path:/mnt/home/mingshiwang/my-dotfiles`
  or `path:.` from the repo. A conventional `git+file` ref (`.`, `.#…`) hides
  the untracked/ignored file and would hit the missing-hardware assertion.
- **Never `git add` the hardware config** — it is generated per machine and
  gitignored; staging it is a mistake.
- **Pre-install dry-run** — to evaluate the flake before the target's file
  exists, deliberately copy the documented stub
  `nixos/hardware-configuration.nix.example` →
  `nixos/hardware-configuration.nix`. It is not imported by default and must
  not be committed as the real config.
- The home-manager configuration is the same `hm.mingshiwang` module the Darwin
  host uses; it is platform-aware and selects the Hyprland desktop UI
  (`modules/features/hyprland.nix`) on Linux.
- WezTerm is installed system-wide (`environment.systemPackages`); the HM
  wezterm module only deploys `.wezterm.lua`. Hyprland's `$terminal` is
  `wezterm`.
- Bluetooth is enabled in the shared baseline (`hardware.bluetooth.enable` +
  `services.blueman.enable`); the Waybar `bluetooth` module opens
  `blueman-manager` on click, and the `network` module opens `nmtui` in
  WezTerm.
- Fan monitoring (`modules/features/fans.nix`) loads the `it87` kernel module
  (B650 GAMING X AX V2) and installs `lm_sensors`.
- Firefox and Vesktop are **user-scoped**: both are installed into the
  `mingshiwang` home-manager profile (`modules/features/firefox.nix`,
  `modules/features/vesktop.nix`) rather than system-wide. This mirrors the
  Darwin host, where Firefox also has a Homebrew cask (see the duplicate-
  ownership note in `TROUBLESHOOTING.md`).
- NVIDIA: open kernel modules (`hardware.nvidia.open = true`) require an RTX
  20-series or newer GPU; no PRIME is configured (single-GPU desktop).
- Login is greetd + tuigreet; it launches the case-sensitive `Hyprland`
  executable under UWSM (`uwsm start Hyprland`).
