{
  lib,
  config,
  osConfig,
  customLib,
  ...
}:
let
  cfg = config._.desktop.packages.nautilus;
  osCfg = osConfig._.desktop.packages.nautilus;
in
{
  options = with lib; {
    _ = {
      desktop.packages.nautilus = customLib.desktop.packages.favorite.mkOption;
    };
  };

  config = lib.mkIf osCfg.enable {
    _ = customLib.desktop.packages.favorite.mkConfig cfg "org.gnome.Nautilus.desktop";
  };
}
