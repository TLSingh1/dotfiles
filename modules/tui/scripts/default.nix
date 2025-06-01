{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    # Git clone helpers using proper script derivations
    (writeScriptBin "git-clone-personal" (builtins.readFile ../../../scripts/git-clone-personal))
    (writeScriptBin "git-clone-work" (builtins.readFile ../../../scripts/git-clone-work))
  ];
} 