# neovim (out-of-store symlink — lazy.nvim needs a writable config dir for
# lazy-lock.json updates; looks.lua reads ~/.config/theme at startup).
# `config` inside the HM module is the home-manager config (provides
# config.lib.file.mkOutOfStoreSymlink and config.home.homeDirectory).
{...}: {
  config.flake.modules.homeManager.nvim = {config, ...}: {
    xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/my-dotfiles/config/nvim";
  };
}
