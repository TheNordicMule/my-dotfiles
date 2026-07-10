# Executable helpers on $PATH.
# (see the user module's home.sessionPath which adds $HOME/bin)
{...}: {
  config.flake.modules.homeManager.bins = {
    home.file."bin/switch".source = ../../bins/switch;
    home.file."bin/theme-switch".source = ../../bins/theme-switch;
    home.file."bin/tmux-sessionizer".source = ../../bins/tmux-sessionizer;
  };
}
