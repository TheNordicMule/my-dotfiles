# Fcitx5 input method with RIME and the 雾凇拼音 (rime-ice) schema.
#
# RIME is the engine; the schema is the actual typing experience. rime-ice is
# an offline, actively maintained simplified-Chinese dictionary with full and
# double pinyin. The nixpkgs `fcitx5-rime` package bakes its shared schema set
# (RIME_DATA_DIR) from `rimeDataPkgs`, so overriding that argument with
# `rime-ice` swaps in the smart schema without any manual plum install.
#
# - nixos.fcitx5: system side — enables fcitx5 and installs the RIME addon
#   (plus the built-in Pinyin addon as a fallback).
# - homeManager.fcitx5: per-user side — declares the enabled input methods
#   (US keyboard + RIME) and the rime-ice default patch.
#
# The schema lives read-only in the Nix store; RIME keeps its writable state
# (compiled `build/` schemas, learned user dict) in ~/.local/share/fcitx5/rime,
# which is left as a real directory (only files are deployed into it).
{
  config,
  ...
}:
{
  config.flake.modules.nixos.fcitx5 = { pkgs, ... }: {
    i18n.inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5.addons = [
        # 雾凇拼音: override the shared schema set baked into fcitx5-rime's
        # RIME_DATA_DIR (default is rime-data; rime-ice supersedes it).
        (pkgs.fcitx5-rime.override { rimeDataPkgs = [ pkgs.rime-ice ]; })
        # Built-in Pinyin + cloud pinyin, kept available as a fallback.
        pkgs.qt6Packages.fcitx5-chinese-addons
      ];
    };
  };

  config.flake.modules.homeManager.fcitx5 = { ... }: {
    # Fcitx's enabled input methods, declaratively. Without this profile it
    # starts with only the US keyboard even though RIME is installed.
    xdg.configFile."fcitx5/profile".text = ''
      [Groups/0]
      Name=Default
      Default Layout=us
      DefaultIM=rime

      [Groups/0/Items/0]
      Name=keyboard-us
      Layout=

      [Groups/0/Items/1]
      Name=rime
      Layout=

      [GroupOrder]
      0=Default
    '';

    # rime-ice ships its default config as `rime_ice_suggestion.yaml` (the
    # nixpkgs package renames upstream default.yaml to avoid clobbering RIME's
    # own default). Pull it in so the 雾凇拼音 `schema_list` and defaults are
    # active. Add extra `patch:` keys here to customize (e.g. switch to a
    # double-pinyin schema already listed in rime_ice_suggestion).
    xdg.dataFile."fcitx5/rime/default.custom.yaml".text = ''
      patch:
        __include: rime_ice_suggestion:/
    '';
  };
}
