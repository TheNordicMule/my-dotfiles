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
#
# Personal skills (anything not bundled with oh-my-opencode-slim) are managed
# fully declaratively: sourced from the Nix store, so a rebuild is required to
# apply edits (the live system always matches the committed config). hm's
# skill-sync only manages its own bundled set, so these coexist untouched with
# plugin-installed skills.
{config, ...}: let
  theme = config.dotfiles.theme;
  # Add a skill name here to manage it declaratively; its folder must exist at
  # config/opencode/skills/<name>/ with a SKILL.md.
  personalSkills = ["learn"];
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

    # Config files claimed by this module.
    # - oh-my-opencode-slim preset: out-of-store symlink so hand-edits to the
    #   repo JSON are live without a rebuild.
    # - personal skills: sourced from the Nix store (rebuild to apply edits),
    #   force = true so the first switch replaces a pre-existing loose copy in
    #   ~/.config/opencode/skills/<name>/ with the store symlink.
    xdg.configFile =
      {
        "opencode/oh-my-opencode-slim.json".source =
          config.lib.file.mkOutOfStoreSymlink
          "${config.home.homeDirectory}/my-dotfiles/config/opencode/oh-my-opencode-slim.json";
      }
      // builtins.listToAttrs (map (skill: {
          name = "opencode/skills/${skill}";
          value = {
            source = ../../config/opencode/skills + "/${skill}";
            force = true;
          };
        })
        personalSkills);
  };
}
