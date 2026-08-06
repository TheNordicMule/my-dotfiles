# Troubleshooting record

## Current status

1. **nixpkgs pin:** `flake.lock` pins nixpkgs to
   `f8e81fc7eb063db454f563cdd596fb96a5ad1497` — the revision currently in use.
   Treat updates as deliberate: advance the lock only when a candidate passes
   the checklist below.
2. **OpenCode override:** `modules/features/opencode.nix` uses the signed
   official OpenCode **v1.17.13** Darwin arm64 release instead of the
   nixpkgs source build. It ad-hoc signs the binary with `rcodesign` and
   disables self-update.

## Symptoms and root causes

- **OpenCode:** The nixpkgs package's Bun-built binary was rejected by macOS
  27 (Sequoia) because it emitted an invalid code signature. The override
  fetches the upstream release, signs it after installation, and prevents an
  auto-update from replacing the signed binary. On Linux the override is never
  forced: `opencodePackage` in `modules/features/opencode.nix` selects the
  Darwin fixed derivation only when the host is macOS, so Home Manager uses
  the native `pkgs.opencode` package on Linux.

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

## Update and test checklist

- [ ] Review the upstream fixes and choose a candidate nixpkgs revision.
- [ ] Update only nixpkgs first, then inspect `flake.lock` and keep the
      change easy to revert:
      `nix flake lock --update-input nixpkgs`
- [ ] Run a full host build (including Home Manager and OpenCode):
      `nix build .#darwinConfigurations.Mac-that-vim.system --no-link`
      or `sudo darwin-rebuild build --flake .#Mac-that-vim`.
- [ ] Only after the full build passes, activate with:
      `sudo darwin-rebuild switch --flake .#Mac-that-vim`
- [ ] Verify OpenCode reports `1.17.13` and launches successfully after the
      candidate update.

Do not use `switch` as the first test: it changes the running system. If a
candidate fails, restore the previous lock revision and rebuild before trying
another update.

## When to remove the workarounds

- **nixpkgs pin:** Remove or advance the pin only when an upstream revision
  passes the full host build on this Mac.
- **OpenCode override:** Remove it only when the normal `pkgs.opencode` build
  produces a valid macOS 27 code signature and the resulting binary builds,
  installs, and launches successfully. At that point, confirm the desired
  update behavior before restoring the nixpkgs package.

## Upstream references

- OpenCode [issue #15124](https://github.com/anomalyco/opencode/issues/15124)
- OpenCode [issue #18503](https://github.com/anomalyco/opencode/issues/18503)
