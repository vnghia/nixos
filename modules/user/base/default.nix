{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config._.user;
  rootCfg = config._;
in
{
  options = with lib; {
    _ = {
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
  };

  config = {
    users.mutableUsers = false;

    users.users = {
      ${cfg.name} = {
        isNormalUser = true;
        shell = if cfg.shell == "zsh" then pkgs.zsh else null;
        extraGroups =
          (if cfg.groups.wheel then [ "wheel" ] else [ ])
          ++ (
            if cfg.groups.wheel && rootCfg.network.networkManager.enable then [ "networkmanager" ] else [ ]
          );
      };
    };

    _ = {
      shell.zsh.enable = lib.mkIf (cfg.shell == "zsh") true;
    };

    home-manager = {
      users.${cfg.name} = cfg.home;
      useGlobalPkgs = true;
      useUserPackages = true;
      extraSpecialArgs = { inherit inputs; };
      sharedModules = [ ../../home ];
    };
  };
}
