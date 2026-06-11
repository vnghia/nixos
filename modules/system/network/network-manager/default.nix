{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config._.network.networkManager;
  vpnCfg = config._.network.vpn;
  activateDefaultVpnPackage =
    if (vpnCfg.default != null) then
      (pkgs.writeShellApplication (
        let
          vpnCommand = vpnCfg.commands.${vpnCfg.default.type};
        in
        {
          name = "activate-default-vpn";
          runtimeInputs =
            vpnCommand.inputs ++ (if (vpnCfg.default.trustedConnectionFile != null) then [ pkgs.jq ] else [ ]);
          text = ''
            enabled_interfaces=(${
              lib.concatStringsSep " " (
                lib.forEach vpnCfg.default.enabledInterfaces (interface: "\"${interface}\"")
              )
            })
            interface=$1
            status=$2
            connection_id=''${CONNECTION_ID:-null}

            for i in "''${enabled_interfaces[@]}"
            do
              if [ "$interface" == "$i" ] && [ "$status" == "up" ]; then
                echo "Interface $interface is up with connection id $connection_id"

                ${
                  if (vpnCfg.default.trustedConnectionFile != null) then
                    ''trusted_connection=$(cat ${vpnCfg.default.trustedConnectionFile} | jq ".$interface | index(\"$connection_id\") != null")''
                  else
                    "trusted_connection=false"
                }
                if [ "$trusted_connection" == "true" ]; then
                  echo "Connection is trusted. Turning off the default VPN ${vpnCfg.default.type} ..."
                  ${vpnCommand.down}
                elif [ "$(${vpnCommand.check})" == "true" ]; then
                  echo "Connection is untrusted but it is already connected to the default VPN ${vpnCfg.default.type}"
                else
                  echo "Connection is untrusted. Turning on the default VPN ${vpnCfg.default.type} ..."
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
