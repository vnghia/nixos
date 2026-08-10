{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config._.desktop.programs.productivity.libreoffice;
  xdgCfg = config.xdg;
in
{
  options = with lib; {
    _ = {
      desktop.programs.productivity.libreoffice = {
        enable = mkEnableOption "LibreOffice";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.libreoffice-fresh
    ];

    _ = {
      nixos.impermanence.directories = {
        "${xdgCfg.configHome}/libreoffice" = { };
      };
    };
  };
}
