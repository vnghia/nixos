{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config._.desktop.programs.game.steam;
in
{
  options = with lib; {
    _ = {
      desktop.programs.game.steam = {
        enable = mkEnableOption "Steam";
        gamemode = mkEnableOption "Gamemode";
      };
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        programs.steam = {
          enable = true;
          extraCompatPackages = with pkgs; [
            proton-ge-bin
          ];
        };
      }
      (lib.mkIf cfg.gamemode {
        programs.gamemode = {
          enable = true;
        };
      })
    ]
  );
}
