{
  lib,
  config,
  customLib,
  ...
}:
let
  cfg = config._.cli.security.ssh;
in
{
  options = with lib; {
    _ = {
      cli.security.ssh = {
        type = mkOption {
          type = types.nullOr (
            types.enum [
              "tpm"
            ]
          );
          default = null;
        };
        config = {
          tpm = {
            environmentFile = mkOption {
              type = types.nullOr types.path;
              default = null;
            };
          }
          // (customLib.system.nixos.sops.mkRequiresOption);
        };
      };
    };
  };

  config = lib.mkMerge [
    (lib.mkIf (cfg.type == "tpm") {
      services.ssh-tpm-agent = {
        enable = true;
      };
      systemd.user.services.ssh-tpm-agent = lib.mkMerge [
        (lib.mkIf (cfg.config.tpm.environmentFile != null) {
          Service.EnvironmentFile = cfg.config.tpm.environmentFile;
        })
        (customLib.system.nixos.sops.mkSystemdServiceRequirements cfg.config.tpm)
      ];
    })
  ];
}
