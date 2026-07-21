# Troubleshooting record

## Current status

Both local safeguards are still active:

1. **nixpkgs pin:** `flake.lock` pins nixpkgs to
   `f205b5574fd0cb7da5b702a2da51507b7f4fdd1b`. This avoids the Bitwarden
   build failure involving the macOS `ld64` linker.
2. **OpenCode override:** `modules/features/opencode.nix` uses the signed
   official OpenCode **v1.17.13** Darwin arm64 release instead of the
   nixpkgs source build. It ad-hoc signs the binary with `rcodesign` and
   disables self-update.

## Symptoms and root causes

- **Bitwarden:** A nix-darwin build failed while linking Bitwarden/Electron,
  with `ld64` crashing. The failure is in the nixpkgs/macOS toolchain path,
  not in the local Bitwarden configuration. The known-good lock revision is
  retained until a newer revision is proven safe.
- **OpenCode:** The nixpkgs package's Bun-built binary was rejected by macOS
  27 (Sequoia) because it emitted an invalid code signature. The override
  fetches the upstream release, signs it after installation, and prevents an
  auto-update from replacing the signed binary.

## Firefox duplicate ownership

Firefox is currently installed twice: Home Manager's
`modules/features/firefox.nix` owns the settings, extensions, and policies,
while the Homebrew cask in `modules/features/homebrew.nix` provides a
conventional app in `/Applications`. A Nix-store app may not open from
Finder or Spotlight because its bundle lives under an immutable `/nix/store`
path and may not be registered or indexed by macOS LaunchServices and
Spotlight like an `/Applications` app.

Choose one app owner (no configuration changes are made as part of this
record):

- **Home Manager:** keep the Firefox package and its declarative settings,
  extensions, and policies. This favors reproducibility, but the Nix-store
  app may have less conventional Finder/Spotlight integration.
- **Homebrew:** keep the cask as the app owner for normal `/Applications`
  integration. This favors macOS discoverability, but app versioning and the
  Firefox settings/extensions/policies must not be split between two owners.

## Electron insecure exception

`modules/features/base.nix` permits `electron-39.8.10` solely because it is
needed by `bitwarden-desktop`. Electron 39 is end-of-life, but the exception
is still required by the pinned nixpkgs revision. Do not mask this with
`NIXPKGS_ALLOW_INSECURE=1`; the narrow package-level exception documents and
limits the intended dependency.

Remove the exception only after the pinned nixpkgs provides a non-insecure
Bitwarden dependency (or Bitwarden has migrated to a supported Electron
version), and both checks pass without insecure allowances:

```sh
nix build .#darwinPackages.bitwarden-desktop --no-link
nix build .#darwinConfigurations.Mac-that-vim.system --no-link
```

The relevant upstream tracking is Bitwarden Electron migration [PR #20448](https://github.com/bitwarden/clients/pull/20448)
and nixpkgs [issue #526914](https://github.com/NixOS/nixpkgs/issues/526914).

## Update and test checklist

- [ ] Review the upstream fixes and choose a candidate nixpkgs revision.
- [ ] Update only nixpkgs first, then inspect `flake.lock` and keep the
      change easy to revert:
      `nix flake lock --update-input nixpkgs`
- [ ] Run the affected package build before touching the live system:
      `nix build .#darwinPackages.bitwarden-desktop --no-link`
- [ ] Run a full host build (including Home Manager and OpenCode):
      `nix build .#darwinConfigurations.Mac-that-vim.system --no-link`
      or `sudo darwin-rebuild build --flake .#Mac-that-vim`.
- [ ] Only after the package-only and full builds pass, activate with:
      `sudo darwin-rebuild switch --flake .#Mac-that-vim`
- [ ] Verify Bitwarden launches and OpenCode reports `1.17.13` and launches
      successfully after the candidate update.

Do not use `switch` as the first test: it changes the running system. If a
candidate fails, restore the previous lock revision and rebuild before trying
another update.

## When to remove the workarounds

- **nixpkgs pin:** Remove or advance the pin only when an upstream revision
  contains the relevant `ld64`/Bitwarden fix and passes both the
  `bitwarden-desktop` package-only build and the full host build on this Mac,
  with no linker crash.
- **OpenCode override:** Remove it only when the normal `pkgs.opencode` build
  produces a valid macOS 27 code signature and the resulting binary builds,
  installs, and launches successfully. At that point, confirm the desired
  update behavior before restoring the nixpkgs package.

## Upstream references

- nixpkgs [PR #536365](https://github.com/NixOS/nixpkgs/pull/536365)
- nixpkgs [commit 24f2ce170079e66ddde26090a889d888ef9ffa44](https://github.com/NixOS/nixpkgs/commit/24f2ce170079e66ddde26090a889d888ef9ffa44)
- nixpkgs [commit 54a50bf3aa2d868ed2916312073d3ec0cb39f139](https://github.com/NixOS/nixpkgs/commit/54a50bf3aa2d868ed2916312073d3ec0cb39f139)
- OpenCode [issue #15124](https://github.com/anomalyco/opencode/issues/15124)
- OpenCode [issue #18503](https://github.com/anomalyco/opencode/issues/18503)

**Unrelated:** nixpkgs [#414163](https://github.com/NixOS/nixpkgs/issues/414163)
and [PR #414166](https://github.com/NixOS/nixpkgs/pull/414166) do not describe
the `ld64` crash observed here.
