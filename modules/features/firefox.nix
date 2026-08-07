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
{config, ...}: let
  palette = config.dotfiles.palettes.${config.dotfiles.theme};
in {
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
        # SanitizeOnShutdown = {Cookies = true;};
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

        # ── Default search engine: DuckDuckGo (Privacy Guides) ──
        search = {
          force = true;
          default = "ddg";
        };

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
          # Force dark UI everywhere; "auto" would follow the system theme.
          "browser.theme.colorScheme" = "dark";
          "browser.theme.toolbar-theme" = "dark";
          "browser.theme.content-theme" = "dark";
          # Use the installed Nerd Font for every standard web font role.
          "font.name.serif.x-west" = "Iosevka Nerd Font";
          "font.name.sans-serif.x-west" = "Iosevka Nerd Font";
          "font.name.monospace.x-west" = "Iosevka Nerd Font Mono";
          "font.name-list.serif.x-west" = "Iosevka Nerd Font";
          "font.name-list.sans-serif.x-west" = "Iosevka Nerd Font";
          "font.name-list.monospace.x-west" = "Iosevka Nerd Font Mono";
          # Allow the declarative userChrome stylesheet below to apply.
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        };

        userChrome = ''
          :root {
            --theme-base: ${palette.base};
            --theme-surface: ${palette.surface};
            --theme-text: ${palette.text};
            --theme-muted: ${palette.muted};
            --theme-accent: ${palette.accent};
            --theme-blue: ${palette.blue};
            --theme-red: ${palette.red};
            --toolbar-bgcolor: var(--theme-base) !important;
            --toolbar-color: var(--theme-text) !important;
            --lwt-accent-color: var(--theme-base) !important;
            --lwt-text-color: var(--theme-text) !important;
            --lwt-selected-tab-background-color: var(--theme-surface) !important;
            --toolbar-field-background-color: var(--theme-surface) !important;
            --toolbar-field-color: var(--theme-text) !important;
            --toolbar-field-focus-background-color: var(--theme-base) !important;
            --toolbar-field-focus-color: var(--theme-text) !important;
          }

          # Keep Firefox's own controls on the same typeface without styling
          # arbitrary chrome content globally.
          #navigator-toolbox button,
          #navigator-toolbox input,
          #navigator-toolbox label,
          #navigator-toolbox toolbarbutton,
          menupopup menu,
          menupopup menuitem,
          panel button,
          panel input {
            font-family: "Iosevka Nerd Font", sans-serif !important;
          }

          #navigator-toolbox,
          #TabsToolbar,
          #nav-bar,
          #PersonalToolbar {
            background: var(--theme-base) !important;
            color: var(--theme-text) !important;
          }

          .tabbrowser-tab { color: var(--theme-muted) !important; }
          .tabbrowser-tab[selected] { color: var(--theme-text) !important; }
          .tabbrowser-tab:hover .tab-background,
          .tabbrowser-tab[selected] .tab-background {
            background: var(--theme-surface) !important;
          }
          .tabbrowser-tab[selected] .tab-background {
            border-bottom: 2px solid var(--theme-accent) !important;
          }

          #urlbar,
          #searchbar {
            background: var(--theme-surface) !important;
            color: var(--theme-text) !important;
            border-color: var(--theme-surface) !important;
          }
          #urlbar[focused],
          #searchbar:focus-within {
            border-color: var(--theme-accent) !important;
          }
          #urlbar-input,
          .searchbar-textbox {
            color: var(--theme-text) !important;
          }

          menupopup,
          panel {
            --panel-background: var(--theme-surface) !important;
            --panel-color: var(--theme-text) !important;
            background: var(--theme-surface) !important;
            color: var(--theme-text) !important;
            border: 1px solid var(--theme-muted) !important;
          }
          menuitem:hover,
          menuitem[highlight="true"],
          toolbarbutton:hover {
            background: var(--theme-accent) !important;
            color: var(--theme-base) !important;
          }
          menuitem[disabled="true"] { color: var(--theme-muted) !important; }
          .urlbarView-row[selected],
          .urlbarView-row:hover {
            background: var(--theme-accent) !important;
            color: var(--theme-base) !important;
          }
          .urlbarView-url { color: var(--theme-blue) !important; }
          .notification-message { color: var(--theme-text) !important; }
          .identity-color-red { color: var(--theme-red) !important; }
        '';
      };
    };
  };
}
