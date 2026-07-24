{
  lib,
  config,
  osConfig,
  ...
}:
let
  osCfg = osConfig._.programs.nixos.appimage;
  xdgCfg = config.xdg;
in
{
  config = lib.mkIf osCfg.enable {
    _ = {
      nixos.impermanence.directories = {
        "${xdgCfg.cacheHome}/appimage-run" = {
          restic = false;
        };
      };
    };
  };
}
