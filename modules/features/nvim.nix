# neovim (out-of-store symlink — lazy.nvim needs a writable config dir for
# lazy-lock.json updates; looks.lua reads ~/.config/theme at startup).
# `config` inside the HM module is the home-manager config (provides
# config.lib.file.mkOutOfStoreSymlink and config.home.homeDirectory).
{...}: {
  config.flake.modules.homeManager.nvim = {
    pkgs,
    config,
    ...
  }: {
    xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/my-dotfiles/config/nvim";

    # Language servers / tooling used by the Neovim config (previously installed
    # via Mason in config/nvim/lua/plugins/lsp.lua; now managed by Home Manager).
    # `eslint` is the runtime dependency of eslint_d. The old Mason ocamllsp
    # 1.19 pin is dropped because nixpkgs only ships a supported different version.
    home.packages = with pkgs; [
      pyright
      clang-tools
      gopls
      rust-analyzer
      nixd
      nixfmt
      lua-language-server
      stylua
      vscode-js-debug
      eslint
      eslint_d
      prettierd
      vtsls
      copilot-language-server
      vscode-json-languageserver
    ];
  };
}
