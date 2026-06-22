{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config._.packages.gvfs;
  gnomeCfg = config._.desktop.managers.gnome;
in
{
  options = with lib; {
    _ = {
      packages.gvfs = {
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
