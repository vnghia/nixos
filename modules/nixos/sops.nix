{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config._.nixos.sops;
in
{
  options = with lib; {
    _ = {
      nixos.sops = {
        enable = mkEnableOption "SOPS";
        keyFile = mkOption {
          type = types.path;
          default = "/etc/sops/age/keys.txt";
        };
        tpm2 = mkEnableOption "TPM2";
      };
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        sops.age.keyFile = cfg.keyFile;

        environment.systemPackages = with pkgs; [
          age
          sops
        ];

        _ = {
          nixos.impermanence.files = {
            ${cfg.keyFile} = {
              parentDirectory = {
                mode = "0400";
              };
            };
          };
        };
      }
      (lib.mkIf cfg.tpm2 {
        _ = {
          security = {
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
