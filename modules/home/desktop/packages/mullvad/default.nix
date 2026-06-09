{
  lib,
  config,
  osConfig,
  ...
}:
let
  cfg = config._.desktop.packages.mullvad;
  osCfg = osConfig._.network.vpn.mullvad;
in
{
  options = with lib; {
    _ = {
      desktop.packages.mullvad = {
        enable = mkEnableOption "Mullvad";
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
        startMinimized = false;
        unpinnedWindow = true;
        updateDismissedForVersion = "";
      };
    };
  };
}
