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
      mkdir -p $out/share/ccusage
      cp -r . $out/share/ccusage/
      
      mkdir -p $out/bin
      install -m755 dist/index.js $out/bin/ccusage
      
      # Fix the shebang to use Nix's node
      substituteInPlace $out/bin/ccusage \
        --replace "#!/usr/bin/env node" "#!${prev.nodejs}/bin/node"
    '';

    meta = with prev.lib; {
      description = "A CLI tool for analyzing Claude Code usage from local JSONL files";
      homepage = "https://github.com/ryoppippi/ccusage";
      license = licenses.mit;
      maintainers = [ ];
      mainProgram = "ccusage";
    };
  };
}