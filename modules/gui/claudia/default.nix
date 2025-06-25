{
  config,
  pkgs,
  lib,
  ...
}: {
  home.packages = [
    (pkgs.stdenv.mkDerivation {
      pname = "claudia";
      version = "0.1.0";
      
      src = ./.;
      
      dontUnpack = true;
      dontBuild = true;
      
      installPhase = ''
        mkdir -p $out/bin
        cp $src/claudia $out/bin/
        chmod +x $out/bin/claudia
      '';
      
      meta = with lib; {
        description = "Claudia - GUI for Claude Code";
        platforms = platforms.linux;
      };
    })
  ];
}