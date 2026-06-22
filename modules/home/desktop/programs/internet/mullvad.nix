{
  lib,
  config,
  osConfig,
  pkgs,
  ...
}:
let
  cfg = config._.desktop.programs.internet.mullvad;
  osCfg = osConfig._.network.vpn.mullvad;
  xdgCfg = config.xdg;
in
{
  options = with lib; {
    _ = {
      desktop.programs.internet.mullvad = {
        enable = mkEnableOption "Mullvad";
        autostart = mkEnableOption "Autostart";
      };
    };
  };

  config = lib.mkIf (osCfg.enable && cfg.enable) {
    programs.mullvad-vpn = {
      enable = true;
      settings = {
        animateMap = true;
        autoConnect = false;
        browsedForSplitTunnelingApplications = [ ];
        changelogDisplayedForVersion = "";
        enableSystemNotifications = true;
        monochromaticIcon = true;
        preferredLocale = "system";
        startMinimized = if cfg.autostart then true else false;
        unpinnedWindow = true;
        updateDismissedForVersion = "";
      };
    };

    xdg.autostart = lib.mkIf cfg.autostart {
      enable = true;
      entries = [
        "${pkgs.mullvad-vpn}/share/applications/mullvad-vpn.desktop"
      ];
    };

    _ = {
      nixos.impermanence.directories = [
        "${xdgCfg.configHome}/Mullvad VPN"
      ];
    };
  };
}
