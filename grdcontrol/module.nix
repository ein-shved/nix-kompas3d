{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.services.grdcontrol;
in {
  options = {
    services.grdcontrol = {
      enable = lib.mkEnableOption "Guardant service";
    };
  };
  config = lib.mkIf cfg.enable {
    systemd.services.grdcontrol = {
      description = "Guardant Control Center";
      after = ["network.target"];
      wantedBy = ["multi-user.target"];
      serviceConfig = {
        Type = "forking";
        ExecStart = "${pkgs.grdcontrol}/opt/guardant/grdcontrol/grdcontrold --daemon";
        Restart = "on-abort";
      };
    };
  };
}
