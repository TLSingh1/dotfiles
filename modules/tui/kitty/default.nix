{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.kitty = {
    enable = true;
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
      shell = "fish";
      font_family = "monospace";
      font_size = 10;
      enable_audio_bell = true;

      # Material You 3 cyan/teal theme
      background = "#000000"; # base
      background_opacity = "0.15";
      foreground = "#c4e7e8"; # text
      selection_background = "#263738"; # selection
      selection_foreground = "#5eead4"; # yellow (primary 80)
      url_color = "#7dd3c0"; # peach (primary 70)
      cursor = "#d8709a"; # pink - stands out against teal
      cursor_text_color = "#0e1415";
      cursor_trail = 3;
      modify_font = "cell_height 130%";

      # Tabs
      active_tab_background = "#7dd3c0"; # peach (primary 70)
      active_tab_foreground = "#0e1415"; # base
      inactive_tab_background = "#1e2829"; # surface0
      inactive_tab_foreground = "#5f7c7d"; # line_number
      tab_bar_background = "#0e1415"; # base

      # Windows
      active_border_color = "#7dd3c0"; # peach (primary 70)
      inactive_border_color = "#263738"; # selection

      # normal colors - Material You 3 theme
      color0 = "#0e1415"; # black (base)
      color1 = "#f2718b"; # red (error 70)
      color2 = "#34d399"; # green (primary variant 70)
      color3 = "#5eead4"; # yellow (primary 80)
      color4 = "#38bdf8"; # blue (sapphire - secondary 70)
      color5 = "#d8709a"; # magenta (pink - tertiary 60)
      color6 = "#2dd4bf"; # cyan (teal - primary 60)
      color7 = "#c4e7e8"; # white (text)

      # bright colors
      color8 = "#263738"; # bright black (selection)
      color9 = "#e25370"; # bright red (maroon - error 60)
      color10 = "#7dd3c0"; # bright green (peach - primary 70)
      color11 = "#67e8f9"; # bright yellow (sky - secondary 80)
      color12 = "#0891b2"; # bright blue (blue - secondary 50)
      color13 = "#c084fc"; # bright magenta (lavender - secondary variant 70)
      color14 = "#5eead4"; # bright cyan (yellow - primary 80)
      color15 = "#e0f2f3"; # bright white

      # extended colors
      color16 = "#a385cf"; # extended purple (mauve - secondary 70)
      color17 = "#e694b3"; # extended pink (flamingo - tertiary 70)

      # Orange holographic theme (commented for reference)
      # background = "#000000";
      # background_opacity = "0.15";
      # foreground = "#ffd4b0";
      # selection_background = "#3a2015";
      # selection_foreground = "#ffdc00";
      # url_color = "#ff9c64";
      # cursor = "#ff64dc";
      # cursor_text_color = "#0a0505";
      # active_tab_background = "#ff9c64";
      # active_tab_foreground = "#0a0505";
      # inactive_tab_background = "#2a1510";
      # inactive_tab_foreground = "#805030";
      # tab_bar_background = "#0a0505";
      # active_border_color = "#ff9c64";
      # inactive_border_color = "#3a2015";
      # color0 = "#0a0505";
      # color1 = "#ff6464";
      # color2 = "#ffa500";
      # color3 = "#ffdc00";
      # color4 = "#ff9c64";
      # color5 = "#ff64dc";
      # color6 = "#ff8c64";
      # color7 = "#ffd4b0";
      # color8 = "#3a2015";
      # color9 = "#ff7050";
      # color10 = "#ffb08c";
      # color11 = "#ffee00";
      # color12 = "#ffa050";
      # color13 = "#ff64c8";
      # color14 = "#ffa58c";
      # color15 = "#ffe4d0";
      # color16 = "#ff8050";
      # color17 = "#ff4500";

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

