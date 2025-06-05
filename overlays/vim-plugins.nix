# Custom vim plugins not in nixpkgs
final: prev: {
  vimPlugins = prev.vimPlugins // {
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
