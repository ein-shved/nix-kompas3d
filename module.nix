{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.services.kompas3d;
in {
  options = {
    services.kompas3d = {
      enable = lib.mkEnableOption "ASKON Kompas3D";
    };
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.kompas3d
    ];
    services.grdcontrol.enable = true;
  };
}
