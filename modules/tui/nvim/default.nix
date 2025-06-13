{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: {
  imports = [
    inputs.nixCats.homeModule
  ];

  nixCats = {
    enable = true;
    packageNames = ["myNvim"];
    luaPath = ./.;

    # Plugin categories
    categoryDefinitions.replace = {pkgs, ...}: {
      # Startup plugins (always loaded)
      startupPlugins = {
        general = with pkgs.vimPlugins; [
          lze
          lzextras
          plenary-nvim
          promise-async
          nui-nvim
        ];
      };

      # Optional plugins (lazy-loaded)
      optionalPlugins = {
        ai = with pkgs.vimPlugins; [
          supermaven-nvim
        ];
        coding = with pkgs.vimPlugins; [
          nvim-lspconfig
          typescript-tools-nvim
          blink-cmp
          friendly-snippets
          conform-nvim
          nvim-treesitter.withAllGrammars
          nvim-treesitter-textobjects
          ultimate-autopair-nvim
          nvim-surround
          nvim-ts-autotag
          lsp_lines-nvim
        ];
        ui = with pkgs.vimPlugins; [
          toggleterm-nvim
          telescope-nvim
          nvim-tree-lua
          nvim-web-devicons
          catppuccin-nvim
          render-markdown-nvim
          indent-blankline-nvim
          nvim-colorizer-lua
          snacks-nvim
          image-nvim
          diagram-nvim
          img-clip-nvim
          nvim-ufo
          nvim-notify
          noice-nvim
          dashboard-nvim
        ];
        project = with pkgs.vimPlugins; [
          # Project management and navigation tools
          # obsidian-nvim
          # nord-nvim
        ];
        git = with pkgs.vimPlugins; [
          neogit
          diffview-nvim
          gitsigns-nvim
        ];
      };

      # LSPs and runtime dependencies
      lspsAndRuntimeDeps = {
        general = with pkgs; [
          # Core utilities
        ];
        coding = with pkgs; [
          lua-language-server
          stylua # Lua formatter
          nodePackages.prettier # JavaScript/TypeScript/JSON/CSS/HTML formatter
          prettierd # Faster prettier daemon
          black # Python formatter
          isort # Python import sorter
          rustfmt # Rust formatter
          shfmt # Shell script formatter
          taplo # TOML formatter
        ];
        nix = with pkgs; [
          nixd
          alejandra
        ];
        ui = with pkgs; [
          ripgrep
          fd
          imagemagick
          mermaid-cli
          plantuml
          d2
          gnuplot
        ];
        project = with pkgs; [
          # Project management tools
        ];
        git = with pkgs; [
          # Git tools
        ];
        ai = with pkgs; [
          # AI and ML tools
        ];
      };
    };

    packageDefinitions.replace = {
      myNvim = {pkgs, ...}: {
        settings = {
          aliases = ["nvim"];
          wrapRc = true;
        };
        categories = {
          general = true;
          ai = true;
          coding = true;
          ui = true;
          project = true;
          git = true;
          nix = true;
        };
      };
    };
  };
}
