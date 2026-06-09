{
  lib,
  config,
  pkgs,
  customLib,
  ...
}:
let
  cfg = config._.desktop.packages.chromium;
  keepassxcCfg = config._.desktop.packages.keepassxc;
  xdgCfg = config.xdg;
in
{
  options = with lib; {
    _ = {
      desktop.packages.chromium = {
        enable = mkEnableOption "Chromium";
      }
      // customLib.home.desktop.packages.favorite.mkOption;
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        programs.chromium = {
          enable = true;
          package = pkgs.ungoogled-chromium;
          nativeMessagingHosts = (if keepassxcCfg.enable then [ pkgs.keepassxc ] else [ ]);
        };

        _ = {
          system.nixos.impermanence.directories = [
            "${xdgCfg.configHome}/chromium"
            "${xdgCfg.cacheHome}/chromium"
          ];
        };
      }
      (customLib.home.desktop.packages.favorite.mkConfig "chromium-browser.desktop" cfg)
    ]
  );
}
