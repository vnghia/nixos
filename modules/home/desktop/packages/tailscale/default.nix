{
  lib,
  config,
  osConfig,
  ...
}:
let
  cfg = config._.desktop.packages.tailscale;
  osCfg = osConfig._.network.vpn.tailscale;
in
{
  options = with lib; {
    _ = {
      desktop.packages.tailscale = {
        enable = mkEnableOption "Tailscale";
      };
    };
  };

  config = lib.mkIf (osCfg.enable && cfg.enable) {
    services.tailscale-systray.enable = true;
  };
}
