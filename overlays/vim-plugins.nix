# Custom vim plugins not in nixpkgs
final: prev: 
let
  # Pre-fetch the binary for Linux x86_64
  avante-lib-linux = prev.fetchurl {
    url = "https://github.com/yetone/avante.nvim/releases/download/latest/avante_lib-linux.tar.gz";
    sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="; # Will be replaced with correct hash
  };
in {
  vimPlugins = prev.vimPlugins // {
    # Avante.nvim with pre-built binaries
    avante-nvim = prev.vimUtils.buildVimPlugin {
      pname = "avante-nvim";
      version = "2024-12-04";
      src = prev.fetchFromGitHub {
        owner = "yetone";
        repo = "avante.nvim";
        rev = "main";
        sha256 = "sha256-uyBuqgZh7Z+aP5ifaZK8qC8RsMi6r7JKeYBtt46RtZU=";
      };
      
      # Build dependencies
      nativeBuildInputs = with prev; [ 
        gnutar
        gzip
      ];
      
      # Post-install phase to extract pre-built binaries
      postInstall = ''
        # Extract the pre-downloaded binary
        mkdir -p $out/build
        tar xzf ${avante-lib-linux} -C $out/build/
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
