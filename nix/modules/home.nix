# Home-manager user configuration.
#
# All configs are deployed as read-only nix-store symlinks (reproducible,
# versioned) unless noted otherwise. The single `theme` variable below
# propagates to starship, wezterm, nvim, sketchybar, bat, and opencode.
#
# To switch themes: change `theme`, then run `bins/switch` (darwin-rebuild).
{
  config,
  lib,
  pkgs,
  ...
}: let
  # ────────────────────────────────────────────────────────────────────────────
  # Theme — change this one variable to switch all themed tools.
  # Valid values: "nord" | "catppuccin"
  # ────────────────────────────────────────────────────────────────────────────
  theme = "catppuccin";
in {
  home.username = "mingshiwang";
  # mkForce: home-manager's darwin common module derives this from
  # `users.users.<name>.home`, which is null on nix-darwin (existing macOS
  # users aren't declared in `users.users`). Override that derivation rather
  # than declaring the user (which would trigger nix-darwin user management).
  home.homeDirectory = lib.mkForce "/Users/mingshiwang";
  home.stateVersion = "24.11";

  xdg.enable = true;

  # ────────────────────────────────────────────────────────────────────────────
  # Theme file — read at runtime by nvim (looks.lua) and sketchybar (colors.sh)
  # ────────────────────────────────────────────────────────────────────────────
  xdg.configFile."theme".text = theme;

  # ────────────────────────────────────────────────────────────────────────────
  # git (typed module)
  # ────────────────────────────────────────────────────────────────────────────
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Mingshi Wang";
        email = "mingshiwang123@gmail.com";
      };
      core.pager = "delta";
      interactive.diffFilter = "delta --color-only";
      delta = {
        navigate = true;
        light = false;
      };
      merge.conflictstyle = "diff3";
      diff.colorMoved = "default";
    };
  };

  # ────────────────────────────────────────────────────────────────────────────
  # zsh (typed module)
  # ────────────────────────────────────────────────────────────────────────────
  programs.zsh = {
    enable = true;
    dotDir = "${config.xdg.configHome}/zsh";
    oh-my-zsh = {
      enable = true;
      plugins = ["colored-man-pages" "git" "vi-mode"];
    };
    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;
    shellAliases = {
      v = "nvim";
      vim = "nvim";
      npmg = "npm list -g --depth 0";
      cat = "bat";
      grep = "rg";
      ls = "lsd";
      cf1 = "caffeinate -u -t 3600";
      cf2 = "caffeinate -u -t 7200";
    };
    initContent = ''
      bindkey '^n' autosuggest-accept
      ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#5e81ac'

      # BEGIN opam configuration
      [[ ! -r "$HOME/.opam/opam-init/init.zsh" ]] || source "$HOME/.opam/opam-init/init.zsh" > /dev/null 2> /dev/null
      # END opam configuration
    '';
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    OPENCODE_EXPERIMENTAL_BACKGROUND_SUBAGENTS = "true";
  };

  home.sessionPath = [
    "/opt/homebrew/bin"
    "$HOME/bin"
  ];

  # ────────────────────────────────────────────────────────────────────────────
  # fzf (typed module — absorbs FZF_* env vars + zsh integration)
  # ────────────────────────────────────────────────────────────────────────────
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultCommand = "fd";
    fileWidget.command = "fd";
  };

  # ────────────────────────────────────────────────────────────────────────────
  # bat (typed module, theme-aware via `theme`)
  # catppuccin theme is fetched from catppuccin/bat; nord is bundled with bat.
  # ────────────────────────────────────────────────────────────────────────────
  programs.bat = {
    enable = true;
    themes = lib.optionalAttrs (theme == "catppuccin") {
      "Catppuccin Mocha" = {
        src = pkgs.fetchFromGitHub {
          owner = "catppuccin";
          repo = "bat";
          rev = "6810349b28055dce54076712fc05fc68da4b8ec0";
          sha256 = "sha256-lJapSgRVENTrbmpVyn+UQabC9fpV1G1e+CdlJ090uvg=";
        };
        file = "themes/Catppuccin Mocha.tmTheme";
      };
    };
    config.theme =
      if theme == "catppuccin"
      then "Catppuccin Mocha"
      else "Nord";
  };

  # ────────────────────────────────────────────────────────────────────────────
  # ripgrep (typed module)
  # ────────────────────────────────────────────────────────────────────────────
  programs.ripgrep = {
    enable = true;
    arguments = [
      "--smart-case"
      "--follow"
      "--multiline-dotall"
      "--type-add"
      "spec:*.spec.*"
    ];
  };

  # ────────────────────────────────────────────────────────────────────────────
  # tealdeer (typed module — manages config.toml)
  # ────────────────────────────────────────────────────────────────────────────
  programs.tealdeer = {
    enable = true;
  };

  # ────────────────────────────────────────────────────────────────────────────
  # starship (typed module, theme-aware via `palette`)
  # ────────────────────────────────────────────────────────────────────────────
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      palette =
        if theme == "catppuccin"
        then "catppuccin_mocha"
        else "nord";

      palettes = {
        catppuccin_mocha = {
          rosewater = "#f5e0dc";
          flamingo = "#f2cdcd";
          pink = "#f5c2e7";
          mauve = "#cba6f7";
          red = "#f38ba8";
          maroon = "#eba0ac";
          peach = "#fab387";
          yellow = "#f9e2af";
          green = "#a6e3a1";
          teal = "#94e2d5";
          sky = "#89dceb";
          sapphire = "#74c7ec";
          blue = "#89b4fa";
          lavender = "#b4befe";
          text = "#cdd6f4";
          subtext1 = "#bac2de";
          subtext0 = "#a6adc8";
          overlay2 = "#9399b2";
          overlay1 = "#7f849c";
          overlay0 = "#6c7086";
          surface2 = "#585b70";
          surface1 = "#45475a";
          surface0 = "#313244";
          base = "#1e1e2e";
          mantle = "#181825";
          crust = "#11111b";
        };
        nord = {
          rosewater = "#d8dee9";
          flamingo = "#d8dee9";
          pink = "#b48ead";
          mauve = "#b48ead";
          red = "#bf616a";
          maroon = "#bf616a";
          peach = "#d08770";
          yellow = "#ebcb8b";
          green = "#a3be8c";
          teal = "#8fbcbb";
          sky = "#88c0d0";
          sapphire = "#81a1c1";
          blue = "#5e81ac";
          lavender = "#81a1c1";
          text = "#eceff4";
          subtext1 = "#e5e9f0";
          subtext0 = "#d8dee9";
          overlay2 = "#4c566a";
          overlay1 = "#434c5e";
          overlay0 = "#3b4252";
          surface2 = "#4c566a";
          surface1 = "#434c5e";
          surface0 = "#3b4252";
          base = "#2e3440";
          mantle = "#2e3440";
          crust = "#2e3440";
        };
      };

      git_status = {
        conflicted = "🏳";
        ahead = ''🏎💨''${count}'';
        behind = ''🐢''${count}'';
        diverged = "😵";
        untracked = "🤷";
        stashed = "📦";
        modified = "📝";
        staged = ''[++\(''${count}\)](green)'';
        renamed = "👅";
        deleted = "🗑";
      };
    };
  };

  # ────────────────────────────────────────────────────────────────────────────
  # wezterm (file-driven; Nix injects scheme_name based on `theme`)
  # The Lua file has its scheme_name line stripped; it's prepended here.
  # ────────────────────────────────────────────────────────────────────────────
  home.file.".wezterm.lua".text =
    ''
      local scheme_name = "${
        if theme == "catppuccin"
        then "catppuccin-mocha"
        else "nord"
      }"
    ''
    + builtins.readFile ../../wezterm/dot-wezterm.lua;

  # ────────────────────────────────────────────────────────────────────────────
  # neovim (out-of-store symlink — lazy.nvim needs a writable config dir for
  # lazy-lock.json updates; looks.lua reads ~/.config/theme at startup)
  # ────────────────────────────────────────────────────────────────────────────
  xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/my-dotfiles/config/nvim";

  # ────────────────────────────────────────────────────────────────────────────
  # sketchybar (read-only nix-store; colors.sh reads ~/.config/theme at runtime)
  # ────────────────────────────────────────────────────────────────────────────
  xdg.configFile."sketchybar".source = ../../config/sketchybar;

  # ────────────────────────────────────────────────────────────────────────────
  # opencode (out-of-store symlink — node_modules/ and skills/ need a writable
  # dir; tui.json theme is not Nix-controlled, edit it manually if needed)
  # ────────────────────────────────────────────────────────────────────────────
  xdg.configFile."opencode".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/my-dotfiles/config/opencode";

  # ────────────────────────────────────────────────────────────────────────────
  # Static configs (no HM module exists — deployed as read-only nix-store)
  # ────────────────────────────────────────────────────────────────────────────
  xdg.configFile."aerospace".source = ../../config/aerospace;
  xdg.configFile."gh-dash".source = ../../config/gh-dash;

  # ────────────────────────────────────────────────────────────────────────────
  # Executable helpers on $PATH
  # (see home.sessionPath which adds $HOME/bin)
  # ────────────────────────────────────────────────────────────────────────────
  home.file."bin/switch".source = ../../bins/switch;
  home.file."bin/theme-switch".source = ../../bins/theme-switch;
  home.file."bin/tmux-sessionizer".source = ../../bins/tmux-sessionizer;
}
