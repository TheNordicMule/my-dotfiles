# Firefox — declaratively managed via Home Manager.
#
# Firefox is installed and managed declaratively via Home Manager's
# programs.firefox (nixpkgs wrapped Firefox). Extensions, about:config
# prefs, and enterprise policies are all set via HM.
#
# Enterprise policies work on darwin as of nixpkgs #377863 and HM #6913;
# HM bakes policies.json into the wrapped .app bundle's
# Contents/Resources/distribution/, which is the canonical path Firefox
# reads on macOS.
{...}: {
  config.flake.modules.homeManager.firefox = {
    pkgs,
    firefox-addons,
    ...
  }: {
    programs.firefox = {
      enable = true;

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

      profiles.default = {
        id = 0;
        isDefault = true;

        # ── Extensions (all 4 from rycee's firefox-addons collection) ──
        extensions.packages = with firefox-addons.packages.${pkgs.stdenv.hostPlatform.system}; [
          ublock-origin # uBlock Origin — content/ad blocker
          vimium # Vim keyboard shortcuts for browser navigation
          bitwarden # Official Bitwarden password manager
          private-relay # Firefox Relay — email aliases
        ];

        # ── about:config prefs (Privacy Guides — no enterprise policy exists) ──
        settings = {
          # Auto-enable sideloaded extensions so no manual "Allow" clicks
          # are needed on first launch.
          "extensions.autoDisableScopes" = 0;
          # Disable crash report submission (Privacy Guides).
          "browser.crashReports.unsubmittedCheck.enabled" = false;
          "browser.tabs.crashReporting.sendReport" = false;
          # Disable Privacy-Preserving Attribution / ad measurement (Firefox 128+).
          "dom.private-attribution.submission.enabled" = false;
        };
      };
    };
  };
}
