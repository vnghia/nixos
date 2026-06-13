{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config._.desktop.packages.thunderbird;
in
{
  options = with lib; {
    _ = {
      desktop.packages.thunderbird = {
        enable = mkEnableOption "Thunderbird";
        birdtray = mkEnableOption "Birdtray";
      };
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        programs.thunderbird = {
          enable = true;
        };

        _ = {
          system.nixos.impermanence.directories = [ ".thunderbird" ];
        };
      }
      (lib.mkIf cfg.birdtray {
        home.packages = [
          pkgs.birdtray
        ];
      })
    ]
  );
}
