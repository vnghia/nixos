{
  lib,
  pkgs,
  config,
  osConfig,
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
        favorite = mkOption {
          type = types.nullOr types.int;
          default = null;
        };
      };
    };
  };

  config = lib.mkIf osCfg.enable {
    _ = {
      desktop.managers.gnome.favorites = lib.mkIf (cfg.favorite != null) [
        (lib.mkOverride cfg.favorite "org.gnome.Nautilus.desktop")
      ];
    };
  };
}
