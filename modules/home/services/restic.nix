{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config._.services.restic;
  xdgCfg = config.xdg;

  secretPrefix = "services/restic";

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
in
{
  options = with lib; {
    _ = {
      services.restic = {
        enable = mkEnableOption "Restic";
        home = mkOption {
          type = backupSubmodule;
        };
        backups = mkOption {
          type = types.attrsOf backupSubmodule;
          default = { };
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    sops.secrets = lib.mergeAttrsList (
      lib.forEach ([ "home" ] ++ (builtins.attrNames cfg.backups)) (backup: {
        "${secretPrefix}/${backup}/repository" = { };
        "${secretPrefix}/${backup}/password" = { };
        "${secretPrefix}/${backup}/environment" = { };
      })
    );

    home.packages = with pkgs; [
      restic
    ];

    _ = {
      nixos.impermanence.directories = {
        "${xdgCfg.cacheHome}/restic" = {
          restic = false;
        };
      };
    };
  };
}
