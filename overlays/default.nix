# Main overlay that imports and merges all other overlays
final: prev: 
let
  # Import other overlay files
  vimPluginsOverlay = import ./vim-plugins.nix final prev;
  toolsOverlay = import ./tools.nix final prev;
  firefoxOverlay = import ./firefox.nix final prev;
in
# Merge all overlays together
vimPluginsOverlay // toolsOverlay // firefoxOverlay