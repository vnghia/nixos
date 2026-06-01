{
  lib,
  config,
  ...
}:
{
  config = {
    users.users = {
      xana = {
        isNormalUser = true;
        extraGroups = [
          "wheel"
        ]
        ++ (if config.network.networkManager.enable then [ "networkmanager" ] else [ ]);
      };
    };
  };
}
