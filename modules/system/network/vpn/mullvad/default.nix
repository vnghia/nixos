{
  lib,
  config,
  pkgs,
  customLib,
  ...
}:
let
  cfg = config._.network.vpn.mullvad;
in
{
  options = with lib; {
    _ = {
      network.vpn.mullvad = {
        enable = mkEnableOption "Mullvad";
        # https://mullvad.net/en/help/split-tunneling-with-linux-advanced#excluding
        excludeOutgoingTraffics = mkOption {
          type = types.listOf types.str;
          default = [ ];
        };
      };
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        services.mullvad-vpn.enable = true;

        _ = {
          network.vpn.commands = {
            mullvad = {
              inputs = [ pkgs.jq ];
              check = "${pkgs.mullvad}/bin/mullvad status --json | jq '.state == \"connected\"'";
              up = "${pkgs.mullvad}/bin/mullvad connect --wait";
              down = "${pkgs.mullvad}/bin/mullvad disconnect --wait";
            };
          };

          system.nixos.impermanence.directories = [
            {
              directory = "/etc/mullvad-vpn";
              mode = "0600";
            }
            "/var/cache/mullvad-vpn"
          ];
        };
      }
      (lib.mkIf (builtins.length cfg.excludeOutgoingTraffics > 0) {
        networking.firewall.enable = true;

        networking.nftables = {
          enable = true;
          tables = {
            mullvadExcludeIps = {
              name = "mullvad-exclude-outgoing-traffics";
              family = "inet";
              content = ''
                chain mullvad-exclude-outgoing-traffics {
                  type route hook output priority 0; policy accept;
                  ${lib.concatStringsSep "\n" (
                    lib.forEach cfg.excludeOutgoingTraffics (
                      traffic:
                      "${
                        if ((customLib.network.isIpV4 traffic) || (customLib.network.isCdirV4 traffic)) then "ip" else "ip6"
                      } daddr ${traffic} ct mark set 0x00000f41 meta mark set 0x6d6f6c65"
                    )
                  )}
                }
              '';
            };
          };
        };
      })
    ]
  );
}
