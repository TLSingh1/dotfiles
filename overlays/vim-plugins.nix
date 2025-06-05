# Custom vim plugins not in nixpkgs
final: prev: {
  vimPlugins = prev.vimPlugins // {
    # Avante.nvim with build support
    avante-nvim = prev.vimUtils.buildVimPlugin {
      pname = "avante-nvim";
      version = "2024-12-04";
      src = prev.fetchFromGitHub {
        owner = "yetone";
        repo = "avante.nvim";
        rev = "main";  # Using main branch for now
        sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";  # Will error and show correct hash
      };
      
      # Build dependencies
      nativeBuildInputs = with prev; [ 
        gnumake
        cargo
        rustc
        curl
        pkg-config
        openssl
      ];
      
      # Build phase
      buildPhase = ''
        # Run the make command which builds the Rust components
        make
      '';
      
      meta = with prev.lib; {
        description = "AI-powered code assistant for Neovim";
        homepage = "https://github.com/yetone/avante.nvim";
        license = licenses.asl20;
      };
    };
    
    # claude-code-nvim = prev.vimUtils.buildVimPlugin {
    #   pname = "claude-code-nvim";
    #   version = "0.4.2";
    #   src = prev.fetchFromGitHub {
    #     owner = "greggh";
    #     repo = "claude-code.nvim";
    #     rev = "v0.4.2";
    #     sha256 = "sha256-Xs1vR/zfyrvYPthAME39rOtmj31OZHY4eNJFi7hZ3tU=";
    #   };
    #   meta = with prev.lib; {
    #     description = "Claude Code integration for Neovim";
    #     homepage = "https://github.com/greggh/claude-code.nvim";
    #     license = licenses.mit;
    #   };
    # };
  };
}
