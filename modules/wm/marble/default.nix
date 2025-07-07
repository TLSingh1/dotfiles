{ config, pkgs, lib, inputs, ... }:

{
  home.packages = [ inputs.marble.packages.${pkgs.system}.default ];

  # Optional: Enable if you want marble to start automatically
  # You might want to disable other window managers/shells when using marble
  # systemd.user.services.marble = {
  #   Unit = {
  #     Description = "Marble Shell";
  #     After = [ "graphical-session.target" ];
  #   };
  #   Service = {
  #     ExecStart = "${inputs.marble.packages.${pkgs.system}.default}/bin/marble";
  #     Restart = "on-failure";
  #   };
  #   Install = {
  #     WantedBy = [ "default.target" ];
  #   };
  # };
}