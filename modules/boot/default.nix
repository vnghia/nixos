{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config._.boot;
in
{
  options = with lib; {
    _ = {
      boot = {
        type = mkOption {
          type = types.enum [
            "systemd"
            "lanzaboote"
          ];
        };
        lanzaboote = {
          measuredBoot = {
            enable = mkEnableOption "Measured boot";
            pcrs = mkOption {
              type = types.listOf types.int;
              default = [ ];
            };
          };
        };
      };
    };
  };

  config = lib.mkMerge [
    {
      boot.loader.efi.canTouchEfiVariables = false;
      boot.initrd.systemd.enable = true;
    }
    (lib.mkIf (cfg.type == "systemd") {
      boot.loader.systemd-boot.enable = true;
    })
    (lib.mkIf (cfg.type == "lanzaboote") (
      let
        pkiBundle = "/var/lib/sbctl";
        pcrlockDirectory = "/var/lib/pcrlock.d";
        # No need to persist this file because it resides inside already-persisted systemd directory.
        pcrlockPolicy = "/var/lib/systemd/pcrlock.json";
      in
      {
        boot.loader.systemd-boot.enable = lib.mkForce false;

        boot.lanzaboote = lib.mkMerge [
          {
            enable = true;
            inherit pkiBundle;
            autoGenerateKeys = {
              enable = true;
            };
            autoEnrollKeys = {
              # TODO: enable this after a new lanzaboote release which has `includeFirmwareBuiltinKeys`
              enable = false;
              # includeFirmwareBuiltinKeys = true;
            };
          }
          cfg.lanzaboote
          (lib.optionalAttrs cfg.lanzaboote.measuredBoot.enable {
            configurationLimit = 8;
            measuredBoot = {
              inherit pcrlockDirectory;
              inherit pcrlockPolicy;
            };
          })
        ];

        environment.systemPackages = [
          # For debugging and troubleshooting Secure Boot.
          pkgs.sbctl
        ];

        _ = {
          nixos.impermanence = {
            directories = lib.mkMerge [
              {
                ${pkiBundle} = {
                  mode = "0600";
                };
                "/var/lib/auto-cryptenroll" = { };
              }
              (lib.optionalAttrs cfg.lanzaboote.measuredBoot.enable {
                ${pcrlockDirectory} = { };
              })
            ];
          };
        };
      }
    ))
  ];
}
