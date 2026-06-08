{
  lib,
  config,
  customLib,
  ...
}:
let
  cfg = config._.desktop.packages.zen-browser;
  xdgCfg = config.xdg;
in
{
  options = with lib; {
    _ = {
      desktop.packages.zen-browser = {
        enable = mkEnableOption "Zen Browser";
        default = mkEnableOption "Default";
      }
      // customLib.home.desktop.packages.favorite.mkOption
      // customLib.home.desktop.theming.stylix.mkOption;
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        programs.zen-browser = {
          enable = true;
          setAsDefaultBrowser = cfg.default;
        };

        xdg.mimeApps = lib.mkIf cfg.default {
          enable = true;
        };

        _ = {
          system.nixos.impermanence.directories = [
            "${xdgCfg.configHome}/zen"
            "${xdgCfg.cacheHome}/zen"
          ];
        };
      }
      (customLib.home.desktop.packages.favorite.mkConfig "zen-beta.desktop" cfg)
      (customLib.home.desktop.theming.stylix.mkConfig "zen-browser" cfg)
      {
        _ = {
          desktop.packages.zen-browser.stylix.config = {
            profileNames = [ "me" ];
            enableCss = true;
          };
        };
      }
    ]
  );
}
