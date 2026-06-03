{
  lib,
  ...
}:
{
  favorite = {
    mkOption = with lib; {
      favorite = mkOption {
        type = types.nullOr types.int;
        default = null;
      };
    };

    mkConfig = cfg: desktop: {
      desktop.managers.gnome.favorites = lib.mkIf (cfg.favorite != null) [
        (lib.mkOverride cfg.favorite desktop)
      ];
    };
  };
}
