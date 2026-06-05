{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config._.users;
  networkCfg = config._.network;
  impermanenceCfg = config._.system.nixos.impermanence;
in
{
  options = with lib; {
    _ = {
      users = {
        hashedPasswordDirectory = mkOption {
          type = types.path;
          default = "/etc/hashed-passwords";
        };
        users = mkOption {
          type = types.attrsOf (
            types.submodule {
              options = {
                shell = mkOption { type = types.enum [ "zsh" ]; };
                groups = {
                  wheel = mkEnableOption "Wheel";
                  networkManager = mkEnableOption "Network Manager";
                };
                home = mkOption { type = types.attrsOf types.anything; };
              };
            }
          );
        };
      };
    };
  };

  config = lib.mkMerge [
    {
      users.mutableUsers = false;

      users.users = lib.attrsets.concatMapAttrs (userName: userCfg: {
        ${userName} = {
          isNormalUser = true;
          shell = if userCfg.shell == "zsh" then pkgs.zsh else null;
          hashedPasswordFile = "${cfg.hashedPasswordDirectory}/${userName}";
          extraGroups =
            (if userCfg.groups.wheel then [ "wheel" ] else [ ])
            ++ (if userCfg.groups.wheel && networkCfg.networkManager.enable then [ "networkmanager" ] else [ ]);
        };
      }) cfg.users;

      systemd.tmpfiles.settings = {
        "10-hashed-password" = {
          ${cfg.hashedPasswordDirectory} = {
            Z = {
              mode = "0600";
            };
          };
        };
      };

      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs = {
          inherit inputs;
          customLib = (import ../../../lib/home { inherit lib; });
        };
        sharedModules = [ ../../home ];
      };

      home-manager.users = lib.attrsets.concatMapAttrs (userName: userCfg: {
        ${userName} = userCfg.home;
      }) cfg.users;

      _ = {
        shell.zsh.enable = builtins.any (userCfg: userCfg.shell == "zsh") (
          lib.attrsets.attrValues cfg.users
        );
      };
    }
  ];
}
