{
  lib,
  config,
  osConfig,
  ...
}:
let
  cfg = config._.desktop.programs.tailscale;
  osCfg = osConfig._.network.vpn.tailscale;
in
{
  options = with lib; {
    _ = {
      desktop.programs.tailscale = {
        enable = mkEnableOption "Tailscale";
      };
    };
  };

  config = lib.mkIf (osCfg.enable && cfg.enable) {
    services.tailscale-systray.enable = true;
  };
}
