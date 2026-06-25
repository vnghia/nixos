{
  lib,
  config,
  customLib,
  pkgs,
  ...
}:
let
  cfg = config._.desktop.programs.media.loupe;
in
{
  options = with lib; {
    _ = {
      desktop.programs.media.loupe = {
        enable = mkEnableOption "Loupe";
      }
      // customLib.home.desktop.programs.favorite.mkOption;
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        home.packages = with pkgs; [
          loupe
        ];
      }
      (customLib.home.desktop.programs.favorite.mkConfig "org.gnome.Loupe.desktop" cfg)
    ]
  );
}
