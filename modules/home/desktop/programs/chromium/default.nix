{
  lib,
  config,
  pkgs,
  customLib,
  ...
}:
let
  cfg = config._.desktop.programs.chromium;
  keepassxcCfg = config._.desktop.programs.keepassxc;
  xdgCfg = config.xdg;
in
{
  options = with lib; {
    _ = {
      desktop.programs.chromium = {
        enable = mkEnableOption "Chromium";
      }
      // customLib.home.desktop.programs.favorite.mkOption;
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
      (customLib.home.desktop.programs.favorite.mkConfig "chromium-browser.desktop" cfg)
    ]
  );
}
