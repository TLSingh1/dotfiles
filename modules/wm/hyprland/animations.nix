{
  enabled = "yes";
  bezier = [
    "linear, 0.0, 0.0, 1.0, 1.0"
    "md3_standard, 0.2, 0.0, 0, 1.0"
    "md3_decel, 0.05, 0.7, 0.1, 1"
    "md3_accel, 0.3, 0, 0.8, 0.15"
    "overshot, 0.05, 0.9, 0.1, 1.05"
    "hyprnostretch, 0.05, 0.9, 0.1, 1.0"
    "win10, 0, 0, 0, 1"
    "gnome, 0, 0.85, 0.3, 1"
    "funky, 0.46, 0.35, -0.2, 1.2"
  ];
  animation = [
    "borderangle, 1, 100, linear, loop"
    "windows, 1, 2, md3_standard, slide"
    "border, 1, 10, default"
    "fade, 1, 0.0000001, default"
    "workspaces, 1, 4, md3_decel, slide"
    "specialWorkspace, 1, 5, overshot, slidefadevert 50%"
  ];
} 