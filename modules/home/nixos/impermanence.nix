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
      };
    };
  };

  config = lib.mkIf (osCfg.enable && osCfg.home) {
    home.persistence.${osCfg.path} = {
      enable = true;
      allowTrash = true;
      hideMounts = true;
      directories = lib.mapAttrsToList (customLib.nixos.impermanence.mkConfig false (lib.removePrefix homePrefix)) cfg.directories;
      files = lib.mapAttrsToList (customLib.nixos.impermanence.mkConfig true (lib.removePrefix homePrefix)) cfg.files;
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
    };
  };
}
