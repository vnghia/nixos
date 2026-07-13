{
  lib,
  config,
  osConfig,
  pkgs,
  customLib,
  ...
}:
let
  cfg = config._.services.restic;
  xdgCfg = config.xdg;
  homeCfg = config.home;
  homePrefix = "${homeCfg.homeDirectory}/";

  impermanenceOsCfg = osConfig._.nixos.impermanence;
  impermanencePath = if impermanenceOsCfg.enable then impermanenceOsCfg.path else null;
  impermanenceCfg = config._.nixos.impermanence;

  mkImpermanencePath = path: "${homePrefix}${lib.removePrefix homePrefix path}";

  backupNames = [ "home" ] ++ (builtins.attrNames cfg.backups);
in
{
  options = with lib; {
    _ = {
      services.restic = {
        enable = mkEnableOption "Restic";
        home = mkOption {
          type = customLib.services.restic.backupSubmodule;
        };
        backups = mkOption {
          type = types.attrsOf customLib.services.restic.backupSubmodule;
          default = { };
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    sops.secrets = lib.mergeAttrsList (
      lib.forEach backupNames (backup: {
        "${customLib.services.restic.secretPrefix}/${backup}/repository" = { };
        "${customLib.services.restic.secretPrefix}/${backup}/password" = { };
        "${customLib.services.restic.secretPrefix}/${backup}/environment" = { };
      })
    );

    services.restic = {
      enable = true;
      backups = lib.mkMerge [
        {
          home = customLib.services.restic.mkConfig config "home" cfg.home;
        }
        (lib.mapAttrs (name: backup: customLib.services.restic.mkConfig config name backup) cfg.backups)
      ];
    };

    home.packages = with pkgs; [
      restic
    ];

    _ = {
      nixos.impermanence.directories = {
        "${xdgCfg.cacheHome}/restic" = {
          restic = false;
        };
      };

      services.restic.home.paths =
        (customLib.services.restic.mkImpermanencePaths impermanencePath mkImpermanencePath
          impermanenceCfg.directories
        )
        ++ (customLib.services.restic.mkImpermanencePaths impermanencePath mkImpermanencePath
          impermanenceCfg.files
        );
    };
  };
}
