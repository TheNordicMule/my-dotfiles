# zsh (typed home-manager module, theme-aware via `theme`).
# `theme` and the autosuggestion color are captured from the flake-parts
# top-level config and baked into the HM module; `config` inside the HM module
# is the home-manager config (used for xdg.configHome).
{
  config,
  lib,
  ...
}:
let
  autosuggest = config.dotfiles.palettes.${config.dotfiles.theme}.autosuggest;
in
{
  config.flake.modules.homeManager.zsh = { config, ... }: {
    programs.zsh = {
      enable = true;
      dotDir = "${config.xdg.configHome}/zsh";
      oh-my-zsh = {
        enable = true;
        plugins = [
          "colored-man-pages"
          "git"
          "vi-mode"
        ];
      };
      syntaxHighlighting.enable = true;
      autosuggestion.enable = true;
      autosuggestion.highlight = "fg=${autosuggest}";
      # cf1/cf2: keep the system awake for exactly 1 / 2 hours. Both are
      # thin aliases over the shared `cf` helper defined in initContent below,
      # which picks the platform command at runtime (caffeinate on macOS,
      # systemd-inhibit on Linux).
      shellAliases = {
        cf1 = "cf 3600";
        cf2 = "cf 7200";
        v = "nvim";
        vim = "nvim";
        npmg = "npm list -g --depth 0";
        cat = "bat";
        grep = "rg";
        ls = "lsd";
      };
      initContent = ''
        bindkey '^n' autosuggest-accept

        # Keep the system awake for N seconds (used by the cf1/cf2 aliases).
        # macOS: `caffeinate -diu` prevents idle/display/system sleep for `-t`
        # seconds.
        # Linux: `systemd-inhibit` holds the idle+sleep inhibitors while a
        # `sleep` process runs for the same duration.
        cf() {
          local seconds=$1
          case "$(uname -s)" in
            Darwin)
              caffeinate -diu -t "$seconds"
              ;;
            Linux)
              systemd-inhibit --what=idle:sleep --why="cf: keep awake for $seconds seconds" sleep "$seconds"
              ;;
            *)
              echo "cf: unsupported OS: $(uname -s)" >&2
              return 1
              ;;
          esac
        }

        # BEGIN opam configuration
        [[ ! -r "$HOME/.opam/opam-init/init.zsh" ]] || source "$HOME/.opam/opam-init/init.zsh" > /dev/null 2> /dev/null
        # END opam configuration
      '';
    };
  };
}
