{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config._.network.networkManager;
  vpnCfg = config._.network.vpn;
  dnsCfg = config._.network.dns;

  activateDefaultVpnPackage =
    if (vpnCfg.default != null) then
      (pkgs.writeShellApplication (
        let
          vpnCommand = vpnCfg.commands.${vpnCfg.default.type};
        in
        {
          name = "activate-default-vpn";
          runtimeInputs = vpnCommand.inputs ++ [ pkgs.jq ];
          text = ''
            enabled_interfaces=(${
              lib.concatStringsSep " " (
                lib.forEach vpnCfg.default.enabledInterfaces (interface: "\"${interface}\"")
              )
            })
            interface_trusted_connections='${builtins.toJSON vpnCfg.default.interfaceTrustedConnections}'

            interface=$1
            status=$2
            connection_id=''${CONNECTION_ID:-null}

            for enabled_interface in "''${enabled_interfaces[@]}"
            do
              if [ "$interface" == "$enabled_interface" ] && [ "$status" == "up" ]; then
                echo "[activate-default-vpn] Interface $interface is up with connection id $connection_id"

                mapfile -t trusted_connections < <(echo "$interface_trusted_connections" | jq -r ".\"$interface\" // [] | .[]")
                for trusted_connection in "''${trusted_connections[@]}"
                do
                  regex="^$trusted_connection$|^$trusted_connection [0-9]+$"
                  if [[ "$connection_id" =~ $regex ]]; then
                    echo "[activate-default-vpn] Connection is trusted. Turning off the default VPN ${vpnCfg.default.type} ..."
                    ${vpnCommand.down}
                    exit
                  fi
                done

                if [ "$(${vpnCommand.check})" == "true" ]; then
                  echo "[activate-default-vpn] Connection is untrusted but it is already connected to the default VPN ${vpnCfg.default.type}"
                else
                  echo "[activate-default-vpn] Connection is untrusted. Turning on the default VPN ${vpnCfg.default.type} ..."
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

  modifyInterfaceDNSConfigPackage = pkgs.writeShellApplication {
    name = "modify-interface-dns-config";
    runtimeInputs = [ pkgs.jq ];
    text = ''
      interface_configs='${builtins.toJSON dnsCfg.interfaceConfig}'

      interface=$1
      status=$2
      connection_id=''${CONNECTION_ID:-null}

      interface_config=$(echo "$interface_configs" | jq ".\"$interface\"")
      if [ "$interface_config" != "null" ] && [ "$status" == "up" ]; then
        echo "[modify-interface-dns-config] Interface $interface is up with connection id $connection_id"

        mapfile -t modified_connections < <(echo "$interface_config" | jq -r ".connections.[]")
        for modified_connection in "''${modified_connections[@]}"
        do
          regex="^$modified_connection$|^$modified_connection [0-9]+$"
          if [[ "$connection_id" =~ $regex ]]; then
            echo "[modify-interface-dns-config] Connection is in the modifications. Modifying its DNS config ..."
            mapfile -t domains < <(echo "$interface_config" | jq -r ".domains.[]")
            resolvectl domain "$interface" "''${domains[@]}"
            resolvectl dnsovertls "$interface" "$(echo "$interface_config" | jq -r ".dnsOverTls")"
            exit
          fi
        done

        echo "[modify-interface-dns-config] Connection is not in the modifications"
      fi
    '';
  };
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
            {
              source = "${modifyInterfaceDNSConfigPackage}/bin/modify-interface-dns-config";
              type = "basic";
            }
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
