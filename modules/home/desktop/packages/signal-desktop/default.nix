{
  lib,
  config,
  customLib,
  pkgs,
  ...
}:
let
  cfg = config._.desktop.packages.signal-desktop;
  xdgCfg = config.xdg;
in
{
  options = with lib; {
    _ = {
      desktop.packages.signal-desktop = {
        enable = mkEnableOption "Signal Desktop";
      }
      // customLib.home.desktop.packages.favorite.mkOption;
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        home.packages = [ pkgs.signal-desktop ];

        _ = {
          system.nixos.impermanence.directories = [
            "${xdgCfg.configHome}/Signal"
          ];
        };
      }
      (customLib.home.desktop.packages.favorite.mkConfig "signal.desktop" cfg)
    ]
  );
}
