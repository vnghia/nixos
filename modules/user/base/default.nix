{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.user;
in
{
  options = with lib; {
    user = {
      name = mkOption { type = types.str; };
      shell = mkOption { type = types.enum [ "zsh" ]; };
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
      ${cfg.name} = {
        isNormalUser = true;
        shell = if cfg.shell == "zsh" then pkgs.zsh else null;
        extraGroups =
          (if cfg.groups.wheel then [ "wheel" ] else [ ])
          ++ (if cfg.groups.wheel && config.network.networkManager.enable then [ "networkmanager" ] else [ ]);
      };
    };

    shell.zsh.enable = lib.mkIf (cfg.shell == "zsh") true;

    home-manager = {
      users.${cfg.name} = cfg.home;
    };
  };
}
