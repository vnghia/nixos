{
  lib,
  config,
  osConfig,
  ...
}:
let
  osCfg = osConfig._.desktop.programs.game.steam;
  homeCfg = config.home;
  xdgCfg = config.xdg;
in
{
  config = lib.mkIf osCfg.enable {
    _ = {
      nixos.impermanence.directories = {
        "${homeCfg.homeDirectory}/.steam" = { };
        "${xdgCfg.dataHome}/Steam" = { };
      };
    };
  };
}
