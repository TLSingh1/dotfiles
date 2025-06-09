# Custom tools not available in nixpkgs
final: prev: {
  # Add custom tools here
  ccusage = prev.stdenv.mkDerivation rec {
    pname = "ccusage";
    version = "0.6.0";

    src = prev.fetchurl {
      url = "https://registry.npmjs.org/ccusage/-/ccusage-${version}.tgz";
      hash = "sha256-vhX/4eocNNrzOLzTiW5hlV1KgovfdfOJkMZW7v9k8LM=";
    };

    nativeBuildInputs = with prev; [
      nodejs
      makeWrapper
    ];

    unpackPhase = ''
      tar xzf $src
      cd package
    '';

    installPhase = ''
      mkdir -p $out/lib/ccusage
      cp -r dist/* $out/lib/ccusage/

      mkdir -p $out/bin
      cat > $out/bin/ccusage << EOF
      #!${prev.nodejs}/bin/node
      import("$out/lib/ccusage/index.js");
      EOF
      chmod +x $out/bin/ccusage
    '';

    meta = with prev.lib; {
      description = "A CLI tool for analyzing Claude Code usage from local JSONL files";
      homepage = "https://github.com/ryoppippi/ccusage";
      license = licenses.mit;
      maintainers = [];
      mainProgram = "ccusage";
    };
  };
}

