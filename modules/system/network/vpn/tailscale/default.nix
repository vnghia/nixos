{
  lib,
  config,
  ...
}:
let
  cfg = config._.network.vpn.tailscale;
  tailscaleInterfaceName = config.services.tailscale.interfaceName;
in
{
  options = with lib; {
    _ = {
      network.vpn.tailscale = {
        enable = mkEnableOption "Tailscale";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.tailscale = {
      enable = true;
      disableUpstreamLogging = true;
      openFirewall = true;
      extraDaemonFlags = [ "--no-logs-no-support" ];
    };

    networking.firewall = {
      enable = true;
      trustedInterfaces = [ tailscaleInterfaceName ];
    };

    networking.nftables.enable = true;
    systemd.services.tailscaled.serviceConfig.Environment = [
      "TS_DEBUG_FIREWALL_MODE=nftables"
    ];

    _ = {
      system.nixos.impermanence.directories = [
        {
          directory = "/var/lib/tailscale";
          mode = "0600";
        }
      ];
    };
  };
}
