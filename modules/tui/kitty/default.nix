{ config, pkgs, lib, ... }:

{
  programs.kitty = {
    enable = true;
    # Add your kitty configuration here
    settings = {
      # Example settings - customize as needed
      shell = "fish";
      font_family = "monospace";
      font_size = 12;
      enable_audio_bell = false;
      window_padding_width = 5;
    };
  };
} 