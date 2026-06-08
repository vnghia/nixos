{
  inputs,
  lib,
  customLib,
  config,
  pkgs,
  ...
}:
let
  cfg = config._.users;
  networkCfg = config._.network;
  tpm2Cfg = config._.system.security.tpm2;
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
                  tpm2 = mkEnableOption "TPM2";
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

      users.users = lib.mapAttrs (userName: userCfg: {
        isNormalUser = true;
        shell = if userCfg.shell == "zsh" then pkgs.zsh else null;
        hashedPasswordFile = "${cfg.hashedPasswordDirectory}/${userName}";
        extraGroups =
          (if userCfg.groups.wheel then [ "wheel" ] else [ ])
          ++ (if networkCfg.networkManager.enable then [ "networkmanager" ] else [ ])
          ++ (if tpm2Cfg.enable then [ "tss" ] else [ ]);
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
        verbose = false;

        backupCommand = "${pkgs.trash-cli}/bin/trash-put";

        extraSpecialArgs = {
          inherit inputs;
          inherit customLib;
        };
        sharedModules = [
          inputs.zen-browser.homeModules.beta
          ../../home
        ];
      };

      home-manager.users = lib.mapAttrs (userName: userCfg: userCfg.home) cfg.users;

      _ = {
        shell.zsh.enable = builtins.any (userCfg: userCfg.shell == "zsh") (lib.attrValues cfg.users);
      };
    }
  ];
}
