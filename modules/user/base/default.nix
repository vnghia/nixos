{
  lib,
  config,
  ...
}:
let
  cfg = config.user;
in
{
  options = with lib; {
    user = {
      username = mkOption { type = types.str; };
      groups = {
        wheel = mkEnableOption "Wheel";
        networkManager = mkEnableOption "Network Manager";
      };
      home = mkOption { type = types.attrs; };
    };
  };

  config = {
    users.mutableUsers = false;

    users.users = {
      ${cfg.username} = {
        isNormalUser = true;
        extraGroups =
          (if cfg.groups.wheel then [ "wheel" ] else [ ])
          ++ (if cfg.groups.wheel && config.network.networkManager.enable then [ "networkmanager" ] else [ ]);
      };
    };

    home-manager = {
      users.${cfg.username} = cfg.home;
    };
  };
}
