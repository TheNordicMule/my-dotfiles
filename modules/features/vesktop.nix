# Vesktop — Discord client with a declarative Vencord CSS theme.
{ config, ... }:
let
  palette = config.dotfiles.palettes.${config.dotfiles.theme};
in
{
  config.flake.modules.homeManager.vesktop = {
    programs.vesktop = {
      enable = true;
      vencord = {
        themes = {
          "palette.css" = ''
            :root {
              --font-primary: "Iosevka Nerd Font", "gg sans", "Noto Sans", "Helvetica Neue", Helvetica, Arial, sans-serif;
              --background-primary: ${palette.base};
              --background-secondary: ${palette.surface};
              --background-secondary-alt: ${palette.base};
              --background-tertiary: ${palette.base};
              --background-floating: ${palette.surface};
              --background-modifier-hover: ${palette.surface};
              --background-modifier-active: ${palette.accent};
              --background-modifier-selected: ${palette.accent};
              --text-normal: ${palette.text};
              --text-muted: ${palette.muted};
              --header-primary: ${palette.text};
              --header-secondary: ${palette.muted};
              --interactive-normal: ${palette.muted};
              --interactive-hover: ${palette.text};
              --interactive-active: ${palette.text};
              --interactive-muted: ${palette.muted};
              --brand-experiment: ${palette.accent};
              --brand-experiment-560: ${palette.accent};
              --text-link: ${palette.blue};
              --status-positive: ${palette.blue};
              --status-warning: ${palette.accent};
              --status-danger: ${palette.red};
              --mention-background: ${palette.accent};
              --mention-foreground: ${palette.base};
            }
          '';
        };
        settings = {
          enabledThemes = [ "palette.css" ];
        };
      };
    };
  };
}
