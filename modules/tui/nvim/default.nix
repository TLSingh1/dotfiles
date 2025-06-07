{ config, pkgs, inputs, lib, ... }:

{
  # Import nixCats module
  imports = [
    inputs.nixCats.homeModule
  ];

  # Minimal nixCats configuration
  nixCats = {
    enable = true;
    packageNames = [ "myNvim" ];
    luaPath = ./.; # Points to the current directory where init.lua is located

    # Plugin categories
    categoryDefinitions.replace = ({ pkgs, ... }: {
      # Startup plugins (always loaded)
      startupPlugins = {
        general = with pkgs.vimPlugins; [
          lze
          lzextras
          plenary-nvim
          # Library dependencies
          promise-async
        ];
      };

      # Optional plugins (lazy-loaded)
      optionalPlugins = {
        ai = with pkgs.vimPlugins; [
          # AI-powered code completion
          supermaven-nvim
        ];
        coding = with pkgs.vimPlugins; [
          # LSP and language support
          nvim-lspconfig
          typescript-tools-nvim
          # Modern completion engine
          blink-cmp
          friendly-snippets
          # Code formatting
          conform-nvim
          # Syntax highlighting and code parsing
          nvim-treesitter.withAllGrammars
          nvim-treesitter-textobjects
          # Auto-pairing with treesitter support
          ultimate-autopair-nvim
          # Surround text objects
          nvim-surround
          # Auto close and rename HTML/XML tags
          nvim-ts-autotag
          # Better LSP diagnostics display
          lsp_lines-nvim
        ];
        ui = with pkgs.vimPlugins; [
          # Terminal and UI enhancements
          toggleterm-nvim
          telescope-nvim
          nvim-tree-lua
          nvim-web-devicons
          catppuccin-nvim
          # Markdown rendering
          render-markdown-nvim
          # Indentation guides
          indent-blankline-nvim
          # Color highlighter
          nvim-colorizer-lua
          # Snacks - collection of small QoL plugins
          snacks-nvim
          # Image viewing support
          image-nvim
          # Diagram rendering
          diagram-nvim
          # UI framework (used by many plugins)
          nui-nvim
          # Image clipboard support
          img-clip-nvim
          # Better folding
          nvim-ufo
          # Better notifications
          nvim-notify
          # Complete UI replacement for messages, cmdline and popupmenu
          noice-nvim
        ];
        project = with pkgs.vimPlugins; [
          # Project management and navigation tools
        ];
        git = with pkgs.vimPlugins; [
          # Git integration tools
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
          # Language servers
          lua-language-server
          # TypeScript support (typescript-tools.nvim provides its own server)
          # nodejs # Required for typescript-tools.nvim
          # Code formatters
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
          # Nix-specific tools
          nixd
          alejandra
        ];
        ui = with pkgs; [
          # UI and search utilities
          ripgrep
          fd
          # Image viewing dependencies
          imagemagick
          # Diagram renderers
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
    });

    # Package definition
    packageDefinitions.replace = {
      myNvim = { pkgs, ... }: {
        settings = {
          aliases = [ "nvim" ];
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