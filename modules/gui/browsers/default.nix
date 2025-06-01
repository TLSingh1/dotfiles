{ config, pkgs, inputs, lib, ... }:

{
  home.packages = with pkgs; [
    inputs.zen-browser.packages.${pkgs.system}.zen-browser
    code-cursor
  ];
} 