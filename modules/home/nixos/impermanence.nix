{
  lib,
  config,
  osConfig,
  customLib,
  ...
}:
let
  cfg = config._.nixos.impermanence;
  osCfg = osConfig._.nixos.impermanence;
  xdgCfg = config.xdg;
  homeCfg = config.home;
  homePrefix = "${homeCfg.homeDirectory}/";
in
{
  options = with lib; {
    _ = {
      nixos.impermanence = {
        directories = mkOption {
          type = types.attrsOf types.anything;
          default = { };
        };
        files = mkOption {
          type = types.attrsOf types.anything;
          default = { };
        };
        normalizedDirectories = mkOption {
          type = types.attrsOf types.anything;
          readOnly = true;
        };
        normalizedFiles = mkOption {
          type = types.attrsOf types.anything;
          readOnly = true;
        };
      };
    };
  };

  config = lib.mkIf (osCfg.enable && osCfg.home) {
    home.persistence.${osCfg.path} = {
      enable = true;
      allowTrash = true;
      hideMounts = true;
      directories = lib.mapAttrsToList (customLib.nixos.impermanence.mkConfig false) cfg.normalizedDirectories;
      files = lib.mapAttrsToList (customLib.nixos.impermanence.mkConfig true) cfg.normalizedFiles;
    };

    _ = {
      nixos.impermanence = {
        directories = {
          # Audio
          "${xdgCfg.stateHome}/wireplumber" = { };

          "${homePrefix}.gnupg" = {
            mode = "0700";
          };
          "${homePrefix}.ssh" = {
            mode = "0700";
          };
          "${xdgCfg.dataHome}/keyrings" = {
            mode = "0700";
          };
        };
      };

      nixos.impermanence = {
        normalizedDirectories = customLib.nixos.impermanence.mkNormalizedPaths (lib.removePrefix homePrefix) cfg.directories;
        normalizedFiles = customLib.nixos.impermanence.mkNormalizedPaths (lib.removePrefix homePrefix) cfg.files;
      };
    };
  };
}
