# fzf (typed home-manager module — absorbs FZF_* env vars + zsh integration).
{ config, ... }:
let
  palette = config.dotfiles.palettes.${config.dotfiles.theme};
in
{
  config.flake.modules.homeManager.fzf = {
    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
      defaultCommand = "fd";
      fileWidget.command = "fd";
      defaultOptions = [
        "--color=bg:${palette.base},fg:${palette.text},bg+:${palette.surface},fg+:${palette.text},hl:${palette.blue},hl+:${palette.accent},info:${palette.muted},prompt:${palette.accent},pointer:${palette.accent},marker:${palette.accent},spinner:${palette.blue},header:${palette.muted},border:${palette.surface}"
      ];
    };
  };
}
