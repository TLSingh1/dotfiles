{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.fish = {
    enable = true;

    shellAliases = import ./aliases.nix;

    functions = import ./functions.nix {inherit pkgs lib;};

    shellInit = ''
      # Disable fish greeting
      set -g fish_greeting

      # Set fish colors
      set -g fish_color_command blue
      set -g fish_color_param cyan
      set -g fish_color_redirection yellow
      set -g fish_color_comment brblack
      set -g fish_color_error red
      set -g fish_color_escape magenta
      set -g fish_color_operator green
      set -g fish_color_quote yellow
      set -g fish_color_autosuggestion brblack
      set -g fish_color_valid_path --underline

      # Enable vi mode
      fish_vi_key_bindings
    '';

    interactiveShellInit = ''
      # Custom prompt setup if needed
      # (starship should handle this if you're using it)
      zoxide init --cmd cd fish | source

      # Set up fzf key bindings if fzf is available
      if command -v fzf >/dev/null
        fzf_key_bindings
      end
    '';
  };

  home.packages = with pkgs; [
    fishPlugins.fzf-fish
    fishPlugins.colored-man-pages
  ];
}
