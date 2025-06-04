{
  description = "Hyprland workspace preview plugin";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
  };

  outputs = { self, nixpkgs, hyprland }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      
      hyprlandPkg = hyprland.packages.${system}.hyprland;
      hyprlandHeaders = hyprlandPkg.dev;
    in
    {
      packages.${system} = {
        workspace-preview = pkgs.stdenv.mkDerivation {
          pname = "hyprland-workspace-preview";
          version = "0.1.0";
          
          src = ./.;
          
          nativeBuildInputs = with pkgs; [
            pkg-config
            gcc13
            hyprlandPkg
          ];
          
          buildInputs = with pkgs; [
            hyprlandHeaders
            pixman
            libdrm
            mesa
          ];
          
          buildPhase = ''
            g++ -std=c++23 -shared -fPIC \
              $(pkg-config --cflags pixman-1 libdrm hyprland) \
              -o workspace-preview.so \
              src/main.cpp
          '';
          
          installPhase = ''
            mkdir -p $out/lib
            cp workspace-preview.so $out/lib/
          '';
        };
      };
      
      devShells.${system}.default = pkgs.mkShell {
        inputsFrom = [ self.packages.${system}.workspace-preview ];
        
        packages = with pkgs; [
          # Development tools
          clang-tools
          gdb
          valgrind
          
          # For testing
          hyprlandPkg
        ];
        
        shellHook = ''
          echo "Hyprland plugin development environment"
          echo "Build with: nix build"
          echo "Or manually: make"
          echo ""
          echo "To test in nested Hyprland:"
          echo "1. Hyprland (starts nested session)"
          echo "2. hyprctl plugin load $(pwd)/result/lib/workspace-preview.so"
        '';
      };
    };
}