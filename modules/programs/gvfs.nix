{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config._.programs.gvfs;
  gnomeCfg = config._.desktop.managers.gnome;
in
{
  options = with lib; {
    _ = {
      programs.gvfs = {
        enable = mkEnableOption "Gvfs";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.gvfs = {
      enable = true;
      package = if gnomeCfg.enable then pkgs.gnome.gvfs else pkgs.gvfs;
    };
  };
}
