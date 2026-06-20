{
  lib,
  config,
  customLib,
  ...
}:
let
  cfg = config._.desktop.programs.media.mpv;
in
{
  options = with lib; {
    _ = {
      desktop.programs.media.mpv = {
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
