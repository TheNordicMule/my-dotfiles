# Firefox — declaratively managed via Home Manager.
#
# The browser itself is installed via Homebrew cask (`firefox` in
# homebrew.nix), NOT via Home Manager's programs.firefox. nixpkgs Firefox
# is unsigned/ad-hoc-signed, which breaks Golden Gate TCC App Management
# (nixpkgs#535123). The Homebrew cask ships Mozilla's proper Developer ID
# signature, so TCC works reliably.
#
# Enterprise policies are placed via home.file because HM's
# programs.firefox.policies is a no-op on darwin: HM skips the wrapping
# that injects policies into the binary, to preserve macOS code signing.
# Firefox 128+ reads policies.json from ~/Library/Application Support/Mozilla/.
#
# The programs.firefox block below is commented out because it installs the
# nixpkgs wrapped Firefox (unsigned bash trampoline) which can't access its
# TCC-protected container on Golden Gate. Re-enable once nixpkgs#535123 is
# fixed upstream. Extensions and about:config prefs will need to be set
# manually in the Homebrew cask Firefox until then.
{...}: {
  config.flake.modules.homeManager.firefox = {
    pkgs,
    firefox-addons, # unused while programs.firefox is disabled
    ...
  }: {
    # ── programs.firefox — DISABLED (nixpkgs#535123) ──
    # nixpkgs wrapped Firefox is unsigned (bash trampoline executable),
    # so Golden Gate TCC App Management denies it container access.
    # Using Homebrew cask Firefox instead (properly Mozilla-signed).
    #
    # programs.firefox = {
    #   enable = true;
    #
    #   profiles.default = {
    #     id = 0;
    #     isDefault = true;
    #
    #     # ── Extensions (all 4 from rycee's firefox-addons collection) ──
    #     extensions.packages = with firefox-addons.packages.${pkgs.stdenv.hostPlatform.system}; [
    #       ublock-origin # uBlock Origin — content/ad blocker
    #       vimium # Vim keyboard shortcuts for browser navigation
    #       bitwarden # Official Bitwarden password manager
    #       private-relay # Firefox Relay — email aliases
    #     ];
    #
    #     # ── about:config prefs (Privacy Guides — no enterprise policy exists) ──
    #     settings = {
    #       # Auto-enable sideloaded extensions so no manual "Allow" clicks
    #       # are needed on first launch.
    #       "extensions.autoDisableScopes" = 0;
    #       # Disable crash report submission (Privacy Guides).
    #       "browser.crashReports.unsubmittedCheck.enabled" = false;
    #       "browser.tabs.crashReporting.sendReport" = false;
    #       # Disable Privacy-Preserving Attribution / ad measurement (Firefox 128+).
    #       "dom.private-attribution.submission.enabled" = false;
    #     };
    #   };
    # };

    # ── Enterprise policies (Privacy Guides recommendations) ──
    # Placed manually because programs.firefox.policies is a no-op on
    # darwin. Verify they are active via about:policies after first launch.
    home.file."Library/Application Support/Mozilla/policies.json".text = builtins.toJSON {
      policies = {
        DisableTelemetry = true;
        DisableFirefoxStudies = true;
        SearchSuggestEnabled = false;
        FirefoxSuggest = {
          WebSuggestions = false;
          SponsoredSuggestions = false;
        };
        UserMessaging.ExtensionRecommendations = false;
        EnableTrackingProtection = {Category = "strict";};
        HttpsOnlyMode = "force_enabled";
        SanitizeOnShutdown = {Cookies = true;};
        DNSOverHTTPS = {
          Enabled = true;
          Fallback = false;
        };
      };
    };
  };
}
