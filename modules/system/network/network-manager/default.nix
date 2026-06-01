{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.network.networkManager;
in
{
  options = {
    network.networkManager = {
      enable = lib.mkEnableOption "Network Manager";
    };
  };

  config = lib.mkIf cfg.enable {
    networking.networkmanager.enable = true;

    impermanence.directories = [
      "/etc/NetworkManager/system-connections"
      "/var/lib/NetworkManager"
    ];
  };
}
