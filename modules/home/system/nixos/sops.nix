{
  lib,
  pkgs,
  config,
  osConfig,
  ...
}:
let
  cfg = config._.system.nixos.sops;
  osCfg = osConfig._.system.nixos.sops;
  xdgCfg = config.xdg;
in
{
  options = with lib; {
    _ = {
      system.nixos.sops = {
        enable = mkEnableOption "SOPS";
        keyFile = mkOption {
          type = types.path;
          default = "${xdgCfg.configHome}/sops/age/keys.txt";
        };
        tpm2 = mkEnableOption "TPM2";
      };
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        sops = {
          age.keyFile = cfg.keyFile;
          defaultSopsFile = ../../../../secrets/users/${config.home.username}/run/secrets.yaml;
        };

        home.packages =
          with pkgs;
          lib.mkIf (!osCfg.enable) [
            age
            sops
          ];

        _ = {
          system.nixos.impermanence.files = [
            {
              file = cfg.keyFile;
              parentDirectory = {
                mode = "0700";
              };
            }
          ];
        };
      }
      (lib.mkIf cfg.tpm2 {
        sops = {
          age = {
            plugins = [
              pkgs.age-plugin-tpm
            ];
          };
        };

        home.packages =
          with pkgs;
          lib.mkIf (!osCfg.enable) [
            age-plugin-tpm
          ];
      })
    ]
  );
}
