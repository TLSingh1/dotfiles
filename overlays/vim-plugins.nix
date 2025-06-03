# Custom vim plugins not in nixpkgs
final: prev: {
  vimPlugins = prev.vimPlugins // {
    # Add custom vim plugins here
  };
}