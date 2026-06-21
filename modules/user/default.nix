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
  virtualizationCfg = config._.system.virtualization;
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
                homeMode = mkOption {
                  type = types.str;
                  default = "0700";
                };
                shell = mkOption { type = types.enum [ "zsh" ]; };
                groups = {
                  wheel = mkEnableOption "Wheel";
                  networkManager = mkEnableOption "Network Manager";
                  qemu = mkEnableOption "QEMU";
                  tpm2 = mkEnableOption "TPM2";
                };
                home = mkOption { type = types.path; };
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

        createHome = true;
        home = "/home/${userName}";
        homeMode = userCfg.homeMode;
        hashedPasswordFile = "${cfg.hashedPasswordDirectory}/${userName}";

        shell = if userCfg.shell == "zsh" then pkgs.zsh else null;

        extraGroups =
          (if userCfg.groups.wheel then [ "wheel" ] else [ ])
          ++ (
            if (userCfg.groups.networkManager && networkCfg.networkManager.enable) then
              [ "networkmanager" ]
            else
              [ ]
          )
          ++ (if (userCfg.groups.qemu && virtualizationCfg.qemu.enable) then [ "libvirtd" ] else [ ])
          ++ (if (userCfg.groups.tpm2 && tpm2Cfg.enable) then [ "tss" ] else [ ]);
      }) cfg.users;

      systemd.tmpfiles.settings = {
        "99-lock-hashed-password" = {
          ${cfg.hashedPasswordDirectory} = {
            Z = {
              mode = "0000";
            };
          };
        };
        "99-set-home-directory-mode" = lib.mapAttrs' (
          userName: userCfg:
          lib.nameValuePair "/home/${userName}" {
            z = {
              mode = userCfg.homeMode;
            };
          }
        ) cfg.users;
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
          inputs.sops-nix.homeManagerModules.sops

          ../home
        ];
      };

      home-manager.users = lib.mapAttrs (
        userName: userCfg:
        lib.mkMerge [
          {
            config._module.args.secrets =
              customLib.system.nixos.sops.mkSecrets pkgs "user-build-secrets-${userName}"
                ../../secrets/users/${userName}/build/secrets.yaml;
          }
          { imports = [ userCfg.home ]; }
        ]
      ) cfg.users;

      _ = {
        system.shell.zsh.enable = builtins.any (userCfg: userCfg.shell == "zsh") (lib.attrValues cfg.users);
      };
    }
  ];
}
