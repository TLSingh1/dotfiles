{ config, pkgs, inputs, lib, ... }:

{
  home.packages = [ inputs.zen-browser.packages.${pkgs.system}.zen-browser ];
  
  # Declaratively manage userContent.css for Zen Browser
  # This will apply to all Zen Browser profiles
  home.file = {
    ".zen/7s8qq7dj.Default Profile/chrome/userContent.css" = {
      source = ./userContent.css;
      force = true;
    };
  };
}