# fzf (typed home-manager module — absorbs FZF_* env vars + zsh integration).
{...}: {
  config.flake.modules.homeManager.fzf = {
    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
      defaultCommand = "fd";
      fileWidget.command = "fd";
    };
  };
}
