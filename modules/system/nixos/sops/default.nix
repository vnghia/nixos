{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config._.system.nixos.sops;
in
{
  options = with lib; {
    _ = {
      system.nixos.sops = {
        enable = mkEnableOption "SOPS";
        keyFile = mkOption {
          type = types.path;
          default = "/etc/sops/age/key.txt";
        };
        tpm2 = mkEnableOption "TPM2";
      };
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        sops = {
          age = {
            keyFile = cfg.keyFile;
          };
        };

        systemd.tmpfiles.settings = {
          "10-sops-key-file" = {
            ${cfg.keyFile} = {
              z = {
                mode = "0400";
              };
            };
          };
        };

        environment.systemPackages = with pkgs; [
          age
          sops
        ];
      }
      (lib.mkIf cfg.tpm2 {
        _ = {
          system.security = {
            tpm2 = {
              enable = true;
            };
          };
        };

        sops = {
          age = {
            plugins = [
              pkgs.age-plugin-tpm
            ];
          };
        };

        environment.systemPackages = with pkgs; [
          age-plugin-tpm
        ];
      })
    ]
  );
}
