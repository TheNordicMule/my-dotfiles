# zsh (typed home-manager module, theme-aware via `theme`).
# `theme` is captured from the flake-parts top-level config and baked into the
# HM module; `config` inside the HM module is the home-manager config (used for
# xdg.configHome).
{config, ...}: let
  theme = config.dotfiles.theme;
in {
  config.flake.modules.homeManager.zsh = {config, ...}: {
    programs.zsh = {
      enable = true;
      dotDir = "${config.xdg.configHome}/zsh";
      oh-my-zsh = {
        enable = true;
        plugins = ["colored-man-pages" "git" "vi-mode"];
      };
      syntaxHighlighting.enable = true;
      autosuggestion.enable = true;
      autosuggestion.highlight =
        if theme == "catppuccin"
        then "fg=#6c7086"
        else if theme == "gruvbox"
        then "fg=#928374"
        else "fg=#616e88"; # nord
      shellAliases = {
        v = "nvim";
        vim = "nvim";
        npmg = "npm list -g --depth 0";
        cat = "bat";
        grep = "rg";
        ls = "lsd";
        cf1 = "caffeinate -u -t 3600";
        cf2 = "caffeinate -u -t 7200";
      };
      initContent = ''
        bindkey '^n' autosuggest-accept

        # BEGIN opam configuration
        [[ ! -r "$HOME/.opam/opam-init/init.zsh" ]] || source "$HOME/.opam/opam-init/init.zsh" > /dev/null 2> /dev/null
        # END opam configuration
      '';
    };
  };
}
