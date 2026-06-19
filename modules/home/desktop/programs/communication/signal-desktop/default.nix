{
  lib,
  config,
  customLib,
  pkgs,
  ...
}:
let
  cfg = config._.desktop.programs.communication.signal-desktop;
  xdgCfg = config.xdg;
in
{
  options = with lib; {
    _ = {
      desktop.programs.communication.signal-desktop = {
        enable = mkEnableOption "Signal Desktop";
      }
      // customLib.home.desktop.programs.favorite.mkOption;
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
      (customLib.home.desktop.programs.favorite.mkConfig "signal.desktop" cfg)
    ]
  );
}
