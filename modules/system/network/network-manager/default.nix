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

    system.nixos.impermanence.directories = [
      "/etc/NetworkManager/system-connections"
      "/var/lib/NetworkManager"
    ];
  };
}
