{
  lib,
  config,
  osConfig,
  ...
}:
let
  virtualisationCfg = osConfig._.virtualisation;
  homeCfg = config.home;
  xdgCfg = config.xdg;
in
{
  config = lib.mkIf virtualisationCfg.podman.enable {
    _ = {
      nixos.impermanence.directories = {
        "${homeCfg.homeDirectory}/.docker" = {
          restic = false;
        };
        "${xdgCfg.dataHome}/containers" = {
          restic = false;
        };
      };
    };
  };
}
