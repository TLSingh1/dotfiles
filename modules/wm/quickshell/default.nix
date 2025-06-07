{ config, pkgs, inputs, ... }:

{
  home.packages = with pkgs; [
    inputs.quickshell.packages.${pkgs.system}.default
  ];
}