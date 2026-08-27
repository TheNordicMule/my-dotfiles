# neovim (out-of-store symlink — lazy.nvim needs a writable config dir for
# lazy-lock.json updates; looks.lua reads ~/.config/theme at startup).
# `config` inside the HM module is the home-manager config (provides
# config.lib.file.mkOutOfStoreSymlink and config.home.homeDirectory).
{ ... }: {
  config.flake.modules.homeManager.nvim =
    {
      pkgs,
      config,
      ...
    }:
    {
      xdg.configFile."nvim".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/my-dotfiles/config/nvim";

      # Hybrid lazy.nvim setup: plugins are served from the Nix store via this
      # linkFarm (lazy.nvim's `dev.path` points here; see config/nvim/lua/config/lazy.lua).
      # Entry names must match the plugin names lazy.nvim resolves from the specs.
      # Anything missing here falls back to a normal lazy.nvim git install.
      # nvim-treesitter is excluded on purpose: the config uses its `main` branch
      # with runtime parser installs, while nixpkgs ships the old master branch.
      xdg.dataFile."nvim/nix-plugins".source = pkgs.linkFarm "nvim-nix-plugins" (
        let
          vp = pkgs.vimPlugins;
        in
        [
          {
            name = "blink.cmp";
            path = vp.blink-cmp;
          }
          {
            name = "blink.compat";
            path = vp.blink-compat;
          }
          {
            name = "cmp-dap";
            path = vp.cmp-dap;
          }
          {
            name = "LuaSnip";
            path = vp.luasnip;
          }
          {
            name = "friendly-snippets";
            path = vp.friendly-snippets;
          }
          {
            name = "lazydev.nvim";
            path = vp.lazydev-nvim;
          }
          {
            name = "lspkind.nvim";
            path = vp.lspkind-nvim;
          }
          {
            name = "nvim-web-devicons";
            path = vp.nvim-web-devicons;
          }
          {
            name = "lualine.nvim";
            path = vp.lualine-nvim;
          }
          {
            name = "catppuccin";
            path = vp.catppuccin-nvim;
          }
          {
            name = "nord.nvim";
            path = vp.nord-nvim;
          }
          {
            name = "gruvbox.nvim";
            path = vp.gruvbox-nvim;
          }
          {
            name = "todo-comments.nvim";
            path = vp.todo-comments-nvim;
          }
          {
            name = "plenary.nvim";
            path = vp.plenary-nvim;
          }
          {
            name = "snacks.nvim";
            path = vp.snacks-nvim;
          }
          {
            name = "which-key.nvim";
            path = vp.which-key-nvim;
          }
          {
            name = "render-markdown.nvim";
            path = vp.render-markdown-nvim;
          }
          {
            name = "mini.nvim";
            path = vp.mini-nvim;
          }
          {
            name = "vim-fugitive";
            path = vp.vim-fugitive;
          }
          {
            name = "gitsigns.nvim";
            path = vp.gitsigns-nvim;
          }
          {
            name = "oil.nvim";
            path = vp.oil-nvim;
          }
          {
            name = "sidekick.nvim";
            path = vp.sidekick-nvim;
          }
          {
            name = "conform.nvim";
            path = vp.conform-nvim;
          }
          {
            name = "neotest";
            path = vp.neotest;
          }
          {
            name = "neotest-gtest";
            path = vp.neotest-gtest;
          }
          {
            name = "neotest-vitest";
            path = vp.neotest-vitest;
          }
          {
            name = "neotest-jest";
            path = vp.neotest-jest;
          }
          {
            name = "harpoon";
            path = vp.harpoon2;
          }
          {
            name = "nvim-dap";
            path = vp.nvim-dap;
          }
          {
            name = "nvim-dap-ui";
            path = vp.nvim-dap-ui;
          }
          {
            name = "nvim-nio";
            path = vp.nvim-nio;
          }
          {
            name = "nvim-dap-virtual-text";
            path = vp.nvim-dap-virtual-text;
          }
          {
            name = "nvim-lspconfig";
            path = vp.nvim-lspconfig;
          }
          {
            name = "fidget.nvim";
            path = vp.fidget-nvim;
          }
          {
            name = "nvim-lint";
            path = vp.nvim-lint;
          }
          {
            name = "nvim-autopairs";
            path = vp.nvim-autopairs;
          }
        ]
      );

      # Language servers / tooling used by the Neovim config (previously installed
      # via Mason in config/nvim/lua/plugins/lsp.lua; now managed by Home Manager).
      # `eslint` is the runtime dependency of eslint_d. The old Mason ocamllsp
      # 1.19 pin is dropped because nixpkgs only ships a supported different version.
      home.packages = with pkgs; [
        pyright
        clang-tools
        # C compiler for nvim-treesitter runtime parser builds (provides `cc`)
        gcc
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
        vscode-json-languageserver
      ];
    };
}
