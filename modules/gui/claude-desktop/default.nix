{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  home.packages = [
    inputs.claude-desktop.packages.${pkgs.system}.claude-desktop-with-fhs

    # basic version without MCP support:
    # inputs.claude-desktop.packages.${pkgs.system}.claude-desktop
  ];
}

