{
  lib,
  config,
  customLib,
  ...
}:
let
  cfg = config._.desktop.programs.mpv;
in
{
  options = with lib; {
    _ = {
      desktop.programs.mpv = {
        enable = mkEnableOption "Mpv";
      }
      // customLib.home.desktop.programs.favorite.mkOption;
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        programs.mpv = {
          enable = true;
        };
      }
      (customLib.home.desktop.programs.favorite.mkConfig "mpv.desktop" cfg)
    ]
  );
}
