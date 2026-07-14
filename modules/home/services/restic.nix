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

  impermanenceOsCfg = osConfig._.nixos.impermanence;
  impermanencePath = if impermanenceOsCfg.enable then impermanenceOsCfg.path else null;
  impermanenceCfg = config._.nixos.impermanence;

  mkImpermanencePath = path: "${homeCfg.homeDirectory}/${path}";

  backupNames = [ "home" ] ++ (builtins.attrNames cfg.backups);
in
{
  options = with lib; {
    _ = {
      services.restic = {
        enable = mkEnableOption "Restic";
        home = mkOption {
          type = customLib.services.restic.backupOptions;
        };
        backups = mkOption {
          type = types.attrsOf customLib.services.restic.backupOptions;
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
          impermanenceCfg.normalizedDirectories
        )
        ++ (customLib.services.restic.mkImpermanencePaths impermanencePath mkImpermanencePath
          impermanenceCfg.normalizedFiles
        );
    };
  };
}
