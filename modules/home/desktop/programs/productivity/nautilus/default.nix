{
  lib,
  config,
  customLib,
  pkgs,
  ...
}:
let
  cfg = config._.desktop.programs.productivity.nautilus;
in
{
  options = with lib; {
    _ = {
      desktop.programs.productivity.nautilus = {
        enable = mkEnableOption "Nautilus";
      }
      // customLib.home.desktop.programs.favorite.mkOption;
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        home.packages = [
          pkgs.nautilus
        ];

        _ = {
          desktop.managers.gnome.dconf = {
            org.gnome.nautilus = {
              preferences.default-folder-viewer = "list-view";
              list-view.default-zoom-level = "small";
            };
          };
        };
      }
      (customLib.home.desktop.programs.favorite.mkConfig "org.gnome.Nautilus.desktop" cfg)
    ]
  );
}
