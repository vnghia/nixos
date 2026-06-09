{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config._.network.networkManager;

  vpnCfg = config._.network.vpn;
  vpnCommands = {
    mullvad = {
      inputs = [
        pkgs.curl
        pkgs.jq
      ];
      check = "curl https://am.i.mullvad.net/json | jq .mullvad_exit_ip";
      up = ''
        ${pkgs.mullvad}/bin/mullvad connect --wait
      '';
    };
  };
  activateDefaultVpnPackage =
    if (vpnCfg.default != null) then
      (pkgs.writeShellApplication (
        let
          vpnCommand = vpnCommands.${vpnCfg.default};
        in
        {
          name = "activate-default-vpn";
          runtimeInputs = vpnCommand.inputs;
          text = ''
            enabled_interfaces=(${
              lib.concatStringsSep " " (lib.forEach vpnCfg.enabledInterfaces (interface: "\"${interface}\""))
            })

            interface=$1 status=$2
            for i in "''${enabled_interfaces[@]}"
            do
              if [ "$interface" == "$i" ] && [ "$status" == "up" ]; then
                echo "Interface $interface is up"

                connected=$(${vpnCommand.check})
                if [ "$connected" == "true" ]; then
                  echo "Already connected to the default VPN ${vpnCfg.default}"
                else
                  echo "Connecting to default VPN ${vpnCfg.default} ..."
                  ${vpnCommand.up}
                fi

                exit
              fi
            done
          '';
        }
      ))
    else
      null;
in
{
  options = with lib; {
    _ = {
      network.networkManager = {
        enable = mkEnableOption "Network Manager";
        wifi = {
          backend = mkOption { type = types.nullOr (types.enum [ "iwd" ]); };
        };
      };
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        networking.networkmanager = {
          enable = true;
          dispatcherScripts = [
            (lib.mkIf (activateDefaultVpnPackage != null) {
              source = "${activateDefaultVpnPackage}/bin/activate-default-vpn";
              type = "basic";
            })
          ];
        };

        _ = {
          system.nixos.impermanence.directories = [
            "/etc/NetworkManager/system-connections"
            "/var/lib/NetworkManager"
          ];
        };
      }
      (lib.mkIf (cfg.wifi.backend == "iwd") {
        networking = {
          wireless.iwd = {
            enable = true;
            settings = {
              Settings = {
                AutoConnect = true;
              };
              General = {
                EnableNetworkConfiguration = true;
                AddressRandomization = "network";
                AddressRandomizationRange = "full";
              };
              Network = {
                EnableIPv6 = true;
              };
              Blacklist = {
                InitialTimeout = 5;
              };
            };
          };

          networkmanager.wifi.backend = "iwd";
        };

        _ = {
          system.nixos.impermanence.directories = [
            "/var/lib/iwd"
          ];
        };
      })
    ]
  );
}
