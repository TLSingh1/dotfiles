# Color mapping configuration for different themes
{
  # Default mapping - uses standard colors
  default = {
    border = {
      active = [ "blue" "green" "yellow" "pink" ];
      inactive = "overlay0";
    };
    shadow = "blue";
    shadowOpacity = "66";
  };
  
  # Vibrant mapping - uses more saturated colors
  vibrant = {
    border = {
      active = [ "pink" "mauve" "blue" "sapphire" ];
      inactive = "overlay1";
    };
    shadow = "mauve";
    shadowOpacity = "88";
  };
  
  # Subtle mapping - uses muted colors
  subtle = {
    border = {
      active = [ "lavender" "text" "subtext1" "subtext0" ];
      inactive = "overlay2";
    };
    shadow = "text";
    shadowOpacity = "44";
  };
  
  # Monochrome mapping - uses grays
  monochrome = {
    border = {
      active = [ "text" "subtext1" "subtext0" "overlay2" ];
      inactive = "surface0";
    };
    shadow = "text";
    shadowOpacity = "33";
  };
}