# opencode (out-of-store symlink — node_modules/ and skills/ need a writable
# dir; tui.json theme is not Nix-controlled, edit it manually if needed).
{...}: {
  config.flake.modules.homeManager.opencode = {config, ...}: {
    xdg.configFile."opencode".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/my-dotfiles/config/opencode";
  };
}
