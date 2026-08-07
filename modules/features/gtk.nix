# GTK — dark theming for GTK apps.
#
# No GTK theme was configured before, so every GTK app (Firefox's system
# theme/title bar, file pickers, …) fell back to light Adwaita under Hyprland.
# This module installs a dark GTK theme, opts GTK3/GTK4 apps into dark mode,
# and reports "prefer-dark" to the desktop portal so apps that follow the
# system color scheme (e.g. Firefox's default theme) render dark.
{...}: {
  config.flake.modules.homeManager.gtk = {pkgs, ...}: {
    gtk = {
      enable = true;
      font = {
        name = "Iosevka Nerd Font";
        size = 11;
      };
      theme = {
        package = pkgs.adw-gtk3;
        name = "adw-gtk3-dark";
      };
      gtk3.extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
      gtk4.extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
    };

    dconf = {
      enable = true;
      settings."org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
    };
  };
}
