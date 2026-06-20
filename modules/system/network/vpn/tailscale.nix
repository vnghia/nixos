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
    };

    networking.firewall = {
      enable = true;
      checkReversePath = "loose";
      trustedInterfaces = [ tailscaleInterfaceName ];
    };

    networking.nftables.enable = true;
    systemd.services.tailscaled.serviceConfig.Environment = [
      "TS_DEBUG_FIREWALL_MODE=nftables"
    ];

    _ = {
      network.vpn.mullvad.excludeOutgoingTraffics = [
        "100.64.0.0/10"
        "fd7a:115c:a1e0::/48"
      ];

      system.nixos.impermanence.directories = [
        {
          directory = "/var/lib/tailscale";
          mode = "0600";
        }
      ];
    };
  };
}
