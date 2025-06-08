{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  programs.ghostty = {
    enable = true;
    package = inputs.ghostty.packages.${pkgs.stdenv.hostPlatform.system}.default;

    settings = {
      font-family = "JetBrains Mono";
      font-size = 12;

      command = "fish";

      window-decoration = false;
      window-padding-x = 10;
      window-padding-y = 10;

      confirm-close-surface = false;
      shell-integration-features = "cursor,sudo,title";

      copy-on-select = false;
    };
  };
}

