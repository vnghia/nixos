{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config._.system.boot;
in
{
  options = with lib; {
    _ = {
      system.boot = {
        type = mkOption {
          type = types.enum [
            "systemd"
            "lanzaboote"
          ];
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
      in
      {
        boot.loader.systemd-boot.enable = lib.mkForce false;

        boot.lanzaboote = {
          enable = true;
          pkiBundle = pkiBundle;
        };

        environment.systemPackages = [
          # For debugging and troubleshooting Secure Boot.
          pkgs.sbctl
        ];

        _ = {
          system.nixos.impermanence.directories = [
            {
              directory = pkiBundle;
              mode = "0600";
            }
          ];
        };
      }
    ))
  ];
}
