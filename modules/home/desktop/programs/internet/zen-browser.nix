{
  lib,
  config,
  pkgs,
  customLib,
  ...
}:
let
  cfg = config._.desktop.programs.internet.zen-browser;
  keepassxcCfg = config._.desktop.programs.productivity.keepassxc;
  xdgCfg = config.xdg;
in
{
  options = with lib; {
    _ = {
      desktop.programs.internet.zen-browser = {
        enable = mkEnableOption "Zen Browser";
        default = mkEnableOption "Default";
        profiles = mkOption {
          type = types.attrsOf types.anything;
        };
      }
      // customLib.home.desktop.programs.favorite.mkOption
      // customLib.home.desktop.theming.stylix.mkOption;
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        programs.zen-browser = {
          enable = true;
          setAsDefaultBrowser = cfg.default;
          nativeMessagingHosts = (if keepassxcCfg.enable then [ pkgs.keepassxc ] else [ ]);
          profiles = cfg.profiles;
        };

        xdg.mimeApps = lib.mkIf cfg.default {
          enable = true;
        };

        _ = {
          nixos.impermanence.directories = {
            "${xdgCfg.configHome}/zen" = { };
            "${xdgCfg.cacheHome}/zen" = { };
          };
        };
      }
      (customLib.home.desktop.programs.favorite.mkConfig "zen-beta.desktop" cfg)
      (customLib.home.desktop.theming.stylix.mkConfig "zen-browser" cfg)
      {
        _ = {
          desktop.programs.internet.zen-browser.stylix.config = {
            enableCss = true;
          };
        };
      }
    ]
  );
}
