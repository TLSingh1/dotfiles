{
  config,
  pkgs,
  lib,
  ...
}: {
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
      font_size = 10;
      enable_audio_bell = true;
      # Orange holographic theme
      background = "#000000";
      background_opacity = "0.15";
      foreground = "#ffd4b0";
      selection_background = "#3a2015";
      selection_foreground = "#ffdc00";
      url_color = "#ff9c64";
      cursor = "#ff64dc";  # Accent magenta - stands out against orange
      cursor_text_color = "#0a0505";
      cursor_trail = 3;
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
      active_tab_background = "#ff9c64";
      active_tab_foreground = "#0a0505";
      inactive_tab_background = "#2a1510";
      inactive_tab_foreground = "#805030";
      tab_bar_background = "#0a0505";

      # Windows
      active_border_color = "#ff9c64";
      inactive_border_color = "#3a2015";

      # normal colors - orange holographic theme
      color0 = "#0a0505"; # black (background)
      color1 = "#ff6464"; # red (coral)
      color2 = "#ffa500"; # green (orange)
      color3 = "#ffdc00"; # yellow
      color4 = "#ff9c64"; # blue (primary orange)
      color5 = "#ff64dc"; # magenta
      color6 = "#ff8c64"; # cyan (amber)
      color7 = "#ffd4b0"; # white (foreground)

      # bright colors
      color8 = "#3a2015"; # bright black
      color9 = "#ff7050"; # bright red (orange-red)
      color10 = "#ffb08c"; # bright green (light orange)
      color11 = "#ffee00"; # bright yellow (electric)
      color12 = "#ffa050"; # bright blue (light orange)
      color13 = "#ff64c8"; # bright magenta
      color14 = "#ffa58c"; # bright cyan (light amber)
      color15 = "#ffe4d0"; # bright white

      # extended colors
      color16 = "#ff8050"; # extended orange
      color17 = "#ff4500"; # extended deep orange

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
