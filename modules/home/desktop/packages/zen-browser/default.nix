{
  lib,
  config,
  osConfig,
  customLib,
  pkgs,
  ...
}:
let
  cfg = config._.desktop.packages.zenBrowser;
  osCfg = osConfig._.desktop.packages.zenBrowser;
  xdgCfg = config.xdg;
in
{
  options = with lib; {
    _ = {
      desktop.packages.zenBrowser = {
        enable = mkEnableOption "Zen Browser";
        default = mkEnableOption "Default";
      }
      // customLib.home.desktop.packages.favorite.mkOption;
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        programs.zen-browser = {
          enable = true;
          setAsDefaultBrowser = cfg.default;
        };

        _ = {
          system.nixos.impermanence.directories = [
            "${xdgCfg.configHome}/zen"
            "${xdgCfg.cacheHome}/zen"
          ];
        };
      }
      (customLib.home.desktop.packages.favorite.mkConfig "zen-beta.desktop" cfg)
    ]
  );
}
