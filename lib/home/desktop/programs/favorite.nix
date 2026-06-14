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

    mkConfig = desktop: cfg: {
      _.desktop.managers.gnome.favorites = lib.mkIf (cfg.favorite != null) (
        lib.mkOrder cfg.favorite [
          desktop
        ]
      );
    };
  };
}
