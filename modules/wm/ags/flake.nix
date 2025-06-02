{
  description = "My AGS Desktop Environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    ags.url = "github:aylur/ags";
    astal = {
      url = "github:aylur/astal";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ags, astal }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    packages.${system} = {
      default = ags.lib.bundle {
        inherit pkgs;
        src = ./src;
        name = "my-desktop";
        entry = "app.ts";
        
        # Additional build dependencies
        extraBuildInputs = with pkgs; [
          dart-sass
        ];
        
        # Additional Astal libraries
        extraPackages = with astal.packages.${system}; [
          astal3
          io
          battery
          hyprland
          # Add more as needed
        ];
      };
    };

    # Development shell for working on the project
    devShells.${system}.default = pkgs.mkShell {
      buildInputs = [
        (ags.packages.${system}.default.override {
          extraPackages = with astal.packages.${system}; [
            astal3
            io
            battery
            hyprland
          ];
        })
      ];
    };
  };
} 