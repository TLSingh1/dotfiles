{
  description = "Hyprland workspace preview plugin";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # Use the same Hyprland as your system - we'll pass this in
    hyprland.url = "github:hyprwm/Hyprland";
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
            clang_18
            hyprlandPkg
          ];
          
          buildInputs = with pkgs; [
            hyprlandHeaders
            pixman
            libdrm
            mesa
            libGL
            wayland
            wayland-protocols
            libinput
            libxkbcommon
            cairo
            pango
            jsoncpp
            libpng
            hyprland.inputs.hyprgraphics.packages.${system}.default
            hyprland.inputs.hyprutils.packages.${system}.default
            hyprland.inputs.hyprlang.packages.${system}.default
            hyprland.inputs.aquamarine.packages.${system}.default
          ];
          
          buildPhase = ''
            clang++ -std=c++23 -shared -fPIC \
              $(pkg-config --cflags pixman-1 libdrm hyprland wayland-server jsoncpp) \
              $(pkg-config --libs jsoncpp) \
              -o workspace-preview.so \
              src/main.cpp
          '';
          
          installPhase = ''
            mkdir -p $out/lib
            cp workspace-preview.so $out/lib/
          '';
        };
        
        workspace-preview-v3 = pkgs.stdenv.mkDerivation {
          pname = "hyprland-workspace-preview-v3";
          version = "0.3.0";
          
          src = ./.;
          
          nativeBuildInputs = with pkgs; [
            pkg-config
            clang_18
            hyprlandPkg
          ];
          
          buildInputs = with pkgs; [
            hyprlandHeaders
            pixman
            libdrm
            mesa
            libGL
            wayland
            wayland-protocols
            libinput
            libxkbcommon
            cairo
            pango
            jsoncpp
            libpng
            hyprland.inputs.hyprgraphics.packages.${system}.default
            hyprland.inputs.hyprutils.packages.${system}.default
            hyprland.inputs.hyprlang.packages.${system}.default
            hyprland.inputs.aquamarine.packages.${system}.default
          ];
          
          buildPhase = ''
            ls -la
            ls -la src/
            clang++ -std=c++23 -shared -fPIC \
              $(pkg-config --cflags pixman-1 libdrm hyprland wayland-server jsoncpp libpng) \
              $(pkg-config --libs jsoncpp libpng) \
              -lGL \
              -o workspace-preview.so \
              src/main-v3.cpp
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
          clang_18
          clang-tools_18
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