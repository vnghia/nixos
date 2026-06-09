{
  lib,
  config,
  customLib,
  ...
}:
let
  cfg = config._.desktop.packages.mpv;
in
{
  options = with lib; {
    _ = {
      desktop.packages.mpv = {
        enable = mkEnableOption "Mpv";
      }
      // customLib.home.desktop.packages.favorite.mkOption;
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        programs.mpv = {
          enable = true;
        };
      }
      (customLib.home.desktop.packages.favorite.mkConfig "mpv.desktop" cfg)
    ]
  );
}
