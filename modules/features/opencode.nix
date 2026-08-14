# opencode (typed home-manager module, theme-aware via `theme`).
#
# Config (opencode.json, tui.json) is managed declaratively by
# programs.opencode. Home Manager installs a local fixed derivation that
# fetches the official release binary (see `opencodeFixed` below).
# Runtime-writable directories such as node_modules/ live in
# ~/.config/opencode/ and are left untouched: the HM module has no cleanup
# script and only claims the specific files below.
#
# Personal skills are managed fully declaratively from the Nix store, so a
# rebuild is required to apply edits and the live system always matches the
# committed config.
{ config, ... }:
let
  theme = config.dotfiles.theme;
  # Add a skill name here to manage it declaratively; its folder must exist at
  # config/opencode/skills/<name>/ with a SKILL.md.
  personalSkills = [ "learn" ];
in
{
  config.flake.modules.homeManager.opencode =
    {
      config,
      pkgs,
      ...
    }:
    let
      # Darwin-only workaround: upstream's pkgs.opencode builds from source with
      # Bun, which emits an invalid code signature on macOS 27 (Sequoia).
      # Fetch the official v1.17.13 release binary directly and re-sign it
      # ad-hoc.  Remove this override once pkgs.opencode builds cleanly on
      # macOS 27.  On Linux this derivation is never forced (see
      # `opencodePackage` below) so its macOS-only darwin-arm64 source and
      # rcodesign step never run there.
      opencodeFixed = pkgs.stdenv.mkDerivation {
        pname = "opencode";
        version = "1.17.13";

        src = pkgs.fetchzip {
          url = "https://github.com/anomalyco/opencode/releases/download/v1.17.13/opencode-darwin-arm64.zip";
          sha256 = "sha256-P2guGyD20YlKcdv58OJeG2wIMSmiYxFFSzMMxdGvbKI=";
          stripRoot = false;
        };

        dontStrip = true;

        nativeBuildInputs = with pkgs; [
          makeWrapper
          rcodesign
        ];

        installPhase = ''
          runHook preInstall
          install -m755 -D "$src/opencode" "$out/bin/opencode"
          runHook postInstall
        '';

        # Ad-hoc re-sign after all modifications to work around macOS 27's
        # rejection of Bun's code signature, then wrap to prevent self-update.
        postFixup = ''
          rcodesign sign --code-signature-flags linker-signed "$out/bin/opencode"
          wrapProgram "$out/bin/opencode" \
            --set OPENCODE_DISABLE_AUTOUPDATE true
        '';

        installCheckPhase = ''
          echo "checking opencode version after re-sign…"
          $out/bin/opencode --version
        '';
      };

      # Darwin: the re-signed fixed derivation above.  Linux: the plain native
      # pkgs.opencode package (no Bun code-signature issue outside macOS).
      opencodePackage = if pkgs.stdenv.hostPlatform.isDarwin then opencodeFixed else pkgs.opencode;
    in
    {
      programs.opencode = {
        enable = true;
        package = opencodePackage;
        settings = {
          autoupdate = false;
          lsp = true;
        };
        tui.theme = theme;
      };

      xdg.configFile = builtins.listToAttrs (
        map (skill: {
          name = "opencode/skills/${skill}";
          value = {
            source = ../../config/opencode/skills + "/${skill}";
            force = true;
          };
        }) personalSkills
      );
    };
}
