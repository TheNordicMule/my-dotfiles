# opencode (typed home-manager module, theme-aware via `theme`).
#
# Config (opencode.json, tui.json) is managed declaratively by
# programs.opencode. The binary stays on Homebrew (package = null) — the
# module installs nothing, only writes config files. Runtime-writable dirs
# (node_modules/, .oh-my-opencode-slim/, skills/) live in ~/.config/opencode/
# and are left untouched: the HM module has no cleanup script and only claims
# the specific files below, so opencode can still install its plugin there.
#
# The oh-my-opencode-slim preset is a large hand-maintained JSON file, kept in
# the repo and symlinked out-of-store so edits are live without a rebuild.
{config, ...}: let
  theme = config.dotfiles.theme;
in {
  config.flake.modules.homeManager.opencode = {config, ...}: {
    programs.opencode = {
      enable = true;
      package = null; # binary installed via Homebrew (anomalyco/tap)
      settings = {
        autoupdate = true;
        plugin = ["oh-my-opencode-slim"];
        agent.explore.disable = true;
        agent.general.disable = true;
        lsp = true;
      };
      tui.theme = theme;
    };

    # oh-my-opencode-slim preset — hand-maintained, out-of-store symlink so
    # edits in the repo are live without a rebuild.
    xdg.configFile."opencode/oh-my-opencode-slim.json".source =
      config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/my-dotfiles/config/opencode/oh-my-opencode-slim.json";
  };
}
