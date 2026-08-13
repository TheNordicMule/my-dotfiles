# NixOS `nixos-desktop` host

x86_64-linux desktop host: UEFI + systemd-boot, NetworkManager, PipeWire,
Docker, zsh, NVIDIA (open kernel modules, RTX 20-series or newer), Bluetooth
(BlueZ), fan monitoring, driverless printing, Steam, Hyprland under UWSM,
greetd + tuigreet login, the Noctalia v5 shell/bar, and home-manager wired
exactly like the Darwin host (`modules/hosts/mac-that-vim.nix`).

The host is assembled in `modules/hosts/nixos-desktop.nix`; the system
configuration lives in class-keyed feature modules under `modules/features/`
(`flake.modules.nixos.{base,packages,nvidia,hyprland,steam,fans,printing}`).
The disk layout is declared declaratively in `nixos/disko.nix` (see below).

## Hardware config policy

`nixos/hardware-configuration.nix` is a **generated, local, ignored
per-machine file** that contains **hardware discovery only**:

- It is produced on the target by `nixos-generate-config --no-filesystems`
  (see below) and is listed in `.gitignore` — it is **never staged or
  committed**.
- Because it is untracked/ignored, `git+file` flake refs (`.`, `.#…`) would
  silently hide it. **Every installer/rebuild command that must see it uses an
  explicit `path:` flake reference** (`path:/mnt/home/…/my-dotfiles`, or
  `path:.` from inside the repo), which copies the working directory verbatim
  including ignored files.
- **Filesystems are Disko's job, not this file's.** The root and `/boot`
  filesystems (and swap, if any) are declared in `nixos/disko.nix`
  (`disko.devices.disk.main`); hardware-config generation **must** pass
  `--no-filesystems` and must not re-declare them.
- The NixOS configuration **requires** this file: there is no silent
  placeholder root filesystem, so evaluating the target without it fails with
  a clear assertion.

## Installer overview

### 1. Stage the repo, then wipe/partition with Disko

Boot the NixOS **unstable** minimal ISO (must match the flake's
`nixpkgs-unstable`). For a clean single-OS UEFI install:

```bash
lsblk
sudo -i
```

> ⚠️ **The Disko command below is intentionally destructive and erases ALL
> data on `/dev/nvme0n1`.** Inspect `lsblk` first to confirm which disk you
> want to wipe. The tracked module targets `/dev/nvme0n1`; if you want to use
> **any other disk**, you **must edit `nixos/disko.nix`**
> (`disko.devices.disk.main.device`) before proceeding.

Clone or copy the repo to somewhere accessible from the installer (the
installed system is empty at this point), for example `/tmp/my-dotfiles`:

```bash
cp -r /path/to/my-dotfiles /tmp/my-dotfiles   # or: git clone … /tmp/my-dotfiles
```

Partition and mount using a direct Disko CLI run against the repo's tracked
declarative module `nixos/disko.nix`:

```bash
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- \
  --mode destroy,format,mount \
  --root-mountpoint /mnt \
  /tmp/my-dotfiles/nixos/disko.nix
```

This runs the repo's tracked `nixos/disko.nix` directly: it **intentionally
destructively** destroys and formats `/dev/nvme0n1`, then mounts the resulting
filesystems under `/mnt`. It does **not** invoke `nixos-install` (that is a
separate step below), and it does **not** add Disko to the installed system —
Disko is already a flake input/module used for the NixOS configuration.

The module targets `disko.devices.disk.main.device = "/dev/nvme0n1"`. Before
using any other disk, you **must** edit that `device` in `nixos/disko.nix`.

Disko mounts the filesystems under `/mnt`. It does **not** copy the `/tmp`
staging source anywhere — the repo must be placed into the installed system
explicitly (next step).

### 2. Place the repo in the installed system

The repo must end up at `/mnt/home/mingshiwang/my-dotfiles` so the absolute
out-of-store config links (`config/nvim`, `config/opencode`, …) resolve after
first boot:

```bash
mkdir -p /mnt/home/mingshiwang
cp -r /tmp/my-dotfiles /mnt/home/mingshiwang/my-dotfiles
```

### 3. Generate the hardware config

```bash
nixos-generate-config --no-filesystems --show-hardware-config --root /mnt \
  > /mnt/home/mingshiwang/my-dotfiles/nixos/hardware-configuration.nix
```

`--show-hardware-config` writes **only** the hardware configuration: it prints
the discovery output to stdout and cannot generate a stray `configuration.nix`,
so the redirect above drops it straight into the gitignored, per-machine
`hardware-configuration.nix` — never stage or commit it. `--no-filesystems` is
required: Disko already declares the root and `/boot` filesystems in
`nixos/disko.nix`, so the file carries **hardware discovery only**.

`modules/hosts/nixos-desktop.nix` imports `nixos/hardware-configuration.nix`
once it is present. Before it is, only lazy evaluations (`nix flake show` over
a `path:` ref) work; forcing the target build fails with an assertion pointing
here.

### 4. Install, then set the password

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

### 5. Reboot

```bash
cd /
umount -R /mnt
reboot
```

After first boot, day-to-day switches use the same flake from the repo home.
Again use `path:.` so the untracked, gitignored hardware config stays visible
(`nh` self-elevates internally, so no `sudo` is needed):

```bash
cd ~/my-dotfiles
nh os switch path:. -H nixos-desktop
```

## Notes

- **Hardware config is mandatory** — evaluating the target without
  `nixos/hardware-configuration.nix` fails loudly (assertion in
  `modules/hosts/nixos-desktop.nix`). There is no silent fallback layout.
- **No duplicate filesystem declarations** — root, `/boot`, and swap are owned
  by Disko (`nixos/disko.nix`); the generated hardware config only adds
  hardware discovery (`nixos-generate-config --no-filesystems`). Do not
  declare filesystems in both places.
- **No manual partitioning** — direct Disko provisioning
  (`nix run github:nix-community/disko/latest … --mode destroy,format,mount`)
  replaces manual cfdisk/mkfs/mount steps and owns the disk layout, including
  mounts under `/mnt`. Don't partition or mount manually.
- **Disko erases the disk** — the direct Disko provision step destroys all
  data on `/dev/nvme0n1`; verify with `lsblk` and edit `nixos/disko.nix`
  before targeting any other disk.
- **Use `path:` flake refs for anything that must see the hardware config** —
  `nixos-install`/`nh os switch` with `path:/mnt/home/mingshiwang/my-dotfiles`
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
- Bluetooth is enabled in the shared baseline (`hardware.bluetooth.enable`);
  the Blueman GUI is not installed — Noctalia's bluetooth widget (v5
  recommended services) replaces it. `nmtui` remains available as part of the
  NetworkManager package (no separate GUI is added).
- Fan monitoring (`modules/features/fans.nix`) loads the `it87` kernel module
  (B650 GAMING X AX V2) and installs `lm_sensors`.
- Driverless printing (`modules/features/printing.nix`) enables CUPS with Avahi
  mDNS discovery (NSS + firewall for UDP 5353). It adds **no** vendor/model
  drivers or queues — add those at runtime via CUPS (web UI or `lpadmin`).
- Firefox and Vesktop are **user-scoped**: both are installed into the
  `mingshiwang` home-manager profile (`modules/features/firefox.nix`,
  `modules/features/vesktop.nix`) rather than system-wide. This mirrors the
  Darwin host, where Firefox also has a Homebrew cask (see the duplicate-
  ownership note in `TROUBLESHOOTING.md`).
- NVIDIA: open kernel modules (`hardware.nvidia.open = true`) require an RTX
  20-series or newer GPU; no PRIME is configured (single-GPU desktop).
- Login is greetd + tuigreet; it launches the case-sensitive `Hyprland`
  executable under UWSM (`uwsm start Hyprland`).
