{ config, pkgs, lib, ... }:

{
  programs.kitty = {
    enable = true;
    # Add your kitty configuration here
    keybindings = {
      "kitty_mod+alt+k" = "scroll_line_up";
      "kitty_mod+alt+j" = "scroll_line_down";
      "ctrl+backspace" = "close_window";
      "kitty_mod+l" = "next_window";
      "kitty_mod+h" = "previous_window";
      "kitty_mod+alt+l" = "move_window_forward";
      "kitty_mod+alt+h" = "move_window_backward";
      "kitty_mod+k" = "next_tab";
      "kitty_mod+j" = "previous_tab";
      "kitty_mod+t" = "new_tab_with_cwd";
      "kitty_mod+x" = "close_tab";
      "kitty_mod+d" = "detach_tab";
      "kitty_mod+alt+d" = "detach_window ask";
      "alt+shift+r" = "set_tab_title";
    };
    settings = {
      # Example settings - customize as needed
      shell = "fish";
      font_family = "monospace";
      font_size = 12;
      enable_audio_bell = true;
      background = "#000000";
      background_opacity = "0.1";
      foreground = "#c8d3f5";
      selection_background = "#2d3f76";
      selection_foreground = "#c8d3f5";
      url_color = "#4fd6be";
      cursor = "#c8d3f5";
      cursor_text_color = "#222436";
      # modify_font = "underline_position 200%";
      modify_font = "cell_height 130%";
      # modify_font = ["cell_height 150%"];
      # modify_font = "cell_height 200%";
      # modify_font = "underline_position 200%";
      # modify_font = "underline_position 200% underline_thickness 200%";
      # modify_font = [
      #   "underline_thickness 200%"
      #   "underline_position 200%"
      # ];
      # modify_font = {
      #   "underline_thickness" = "200%";
      #   "underline_position" = "200%";
      # };

      # Tabs
      active_tab_background = "#82aaff";
      active_tab_foreground = "#1e2030";
      inactive_tab_background = "#2f334d";
      inactive_tab_foreground = "#545c7e";
      # tab_bar_background = "#1b1d2b";

      # Windows
      active_border_color = "#82aaff";
      inactive_border_color = "#2f334d";

      # normal
      color0 = "#1b1d2b";
      color1 = "#ff757f";
      color2 = "#c3e88d";
      color3 = "#ffc777";
      color4 = "#82aaff";
      color5 = "#c099ff";
      color6 = "#86e1fc";
      color7 = "#828bb8";

      # bright
      color8 = "#444a73";
      color9 = "#ff757f";
      color10 = "#c3e88d";
      color11 = "#ffc777";
      color12 = "#82aaff";
      color13 = "#c099ff";
      color14 = "#86e1fc";
      color15 = "#c8d3f5";

      # extended colors
      color16 = "#ff966c";
      color17 = "#c53b53";

      # Mouse
      open_url_with = "default";
      copy_on_select = "yes";

      # Tab bar
      tab_bar_style = "powerline";
      tab_bar_align = "left";
      tab_bar_min_tabs = 2;
      tab_powerline_style = "round";

      # Window
      window_padding_width = "10 20 10 20";
    };
  };
} 
