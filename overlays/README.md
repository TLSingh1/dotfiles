# NixOS Overlays

This directory contains overlays for extending nixpkgs with custom packages.

## Structure

- `default.nix` - Main overlay file that's imported by the flake
- `vim-plugins.nix` - Custom vim/neovim plugins not in nixpkgs
- `tools.nix` - Custom CLI tools and applications
- `firefox.nix` - Firefox extensions and themes

## Usage

### Adding a new vim plugin

1. Find the plugin on GitHub
2. Add it to `vim-plugins.nix`:
```nix
my-plugin = prev.vimUtils.buildVimPlugin {
  pname = "plugin-name";
  version = "2024-01-01";
  src = prev.fetchFromGitHub {
    owner = "github-username";
    repo = "repo-name";
    rev = "commit-or-tag";
    sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };
};
```

3. Get the correct sha256:
```bash
nix-prefetch-github owner repo --rev commit-or-tag
```

4. Use in your nvim config:
```nix
optionalPlugins = {
  custom = with pkgs.vimPlugins; [
    my-plugin
  ];
};
```

### Adding custom tools

1. Add to `tools.nix` based on the language:
   - Shell scripts: `writeShellScriptBin`
   - Go: `buildGoModule`
   - Rust: `rustPlatform.buildRustPackage`
   - Python: `python3Packages.buildPythonApplication`
   - Pre-built binaries: `stdenv.mkDerivation`

2. Install in your config:
```nix
home.packages = with pkgs; [
  my-custom-tool
];
```

### Firefox themes/extensions

1. Find the extension URL from addons.mozilla.org
2. Add to `firefox.nix`
3. Configure in Home Manager:
```nix
programs.firefox.profiles.default.extensions = with pkgs.firefox-addons; [
  my-extension
];
```

## Tips

- Use `nix-prefetch-url` or `nix-prefetch-github` to get sha256 hashes
- Test overlays with: `nix build .#nixosConfigurations.my-nixos.config.system.build.toplevel`
- Check if a package exists: `nix search nixpkgs package-name`