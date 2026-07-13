{
  lib,
  ...
}:
let
  secretPrefix = "services/restic";
in
{
  restic = {
    secretPrefix = secretPrefix;

    backupSubmodule =
      with lib;
      types.submodule {
        options = {
          paths = mkOption {
            type = types.listOf types.path;
          };
          extraBackupArgs = mkOption {
            type = types.listOf types.str;
            default = [ ];
          };
          inhibitsSleep = mkEnableOption "Inhibits sleep";
          timerConfig = mkOption {
            type = types.attrsOf types.anything;
          };
        };
      };

    mkConfig =
      config: name: backup:
      let
        userName = lib.attrByPath [ "home" "userName" ] null config;
      in
      lib.mkMerge [
        {
          repositoryFile = config.sops.secrets."${secretPrefix}/${name}/repository".path;
          passwordFile = config.sops.secrets."${secretPrefix}/${name}/password".path;
          environmentFile = config.sops.secrets."${secretPrefix}/${name}/environment".path;
          extraBackupArgs = [
            "--tag=${name}"
          ]
          ++ (
            if userName != null then
              [
                "--tag=user"
                "--tag=${userName}"
              ]
            else
              [ ]
          );
        }
        backup
      ];

    mkImpermanencePaths =
      impermanencePath: mkPath: paths:
      lib.mapAttrsToList (
        path: _: "${lib.optionalString (impermanencePath != null) impermanencePath}${mkPath path}"
      ) (lib.filterAttrs (path: value: lib.attrByPath [ "restic" ] true value) paths);
  };
}
