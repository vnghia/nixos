{
  lib,
  config,
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
      };
    };
  };

  config = lib.mkMerge [
    (lib.mkIf (cfg.type == "tpm") {
      services.ssh-tpm-agent = {
        enable = true;
      };
    })
  ];
}
