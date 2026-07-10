{
  lib,
  config,
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
        extest = mkEnableOption "Extest";
      };
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        programs.steam = {
          enable = true;
          extest = (
            lib.mkIf cfg.extest {
              enable = true;
            }
          );
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
