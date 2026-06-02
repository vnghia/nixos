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
      };
    };
  };

  config = lib.mkIf cfg.enable {
    networking.networkmanager.enable = true;

    _ = {
      system.nixos.impermanence.directories = [
        "/etc/NetworkManager/system-connections"
        "/var/lib/NetworkManager"
      ];
    };
  };
}
