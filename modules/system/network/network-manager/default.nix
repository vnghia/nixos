{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config._.network.networkManager;
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
        networking.networkmanager.enable = true;

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
