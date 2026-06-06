{
  lib,
  config,
  osConfig,
  customLib,
  pkgs,
  ...
}:
let
  cfg = config._.desktop.packages.nautilus;
  osCfg = osConfig._.desktop.packages.nautilus;
in
{
  options = with lib; {
    _ = {
      desktop.packages.nautilus = {
        enable = mkEnableOption "Nautilus";
      }
      // customLib.desktop.packages.favorite.mkOption;
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      { home.packages = [ pkgs.nautilus ]; }
      (customLib.desktop.packages.favorite.mkConfig "org.gnome.Nautilus.desktop" cfg)
    ]
  );
}
