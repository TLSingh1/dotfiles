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
      
      nativeBuildInputs = [ pkgs.autoPatchelfHook ];
      
      buildInputs = with pkgs; [
        openssl
        webkitgtk_4_1
        gtk3
        libayatana-appindicator
        librsvg
        glib
        cairo
        pango
        gdk-pixbuf
        at-spi2-core
        libsoup_3
      ];
      
      dontUnpack = true;
      dontBuild = true;
      
      installPhase = ''
        mkdir -p $out/bin
        cp $src/claudia $out/bin/
        chmod +x $out/bin/claudia
        
        mkdir -p $out/share/applications
        cat > $out/share/applications/claudia.desktop << EOF
        [Desktop Entry]
        Name=Claudia
        Comment=GUI for Claude Code
        Exec=$out/bin/claudia
        Icon=claudia
        Type=Application
        Categories=Development;
        Terminal=false
        EOF
      '';
      
      meta = with lib; {
        description = "Claudia - GUI for Claude Code";
        platforms = platforms.linux;
      };
    })
  ];
}