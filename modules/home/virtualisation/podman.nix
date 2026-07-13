{
  lib,
  config,
  osConfig,
  ...
}:
let
  virtualisationCfg = osConfig._.virtualisation;
  xdgCfg = config.xdg;
in
{
  config = lib.mkIf virtualisationCfg.podman.enable {
    _ = {
      nixos.impermanence.directories = {
        "${xdgCfg.dataHome}/containers" = { };
      };
    };
  };
}
