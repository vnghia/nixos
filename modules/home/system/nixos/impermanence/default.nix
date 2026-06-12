{
  lib,
  config,
  osConfig,
  ...
}:
let
  cfg = config._.system.nixos.impermanence;
  osCfg = osConfig._.system.nixos.impermanence;
  xdgCfg = config.xdg;

  homePrefix = "${config.home.homeDirectory}/";
  removeHomePrefix = (
    file: path:
    if (lib.isString path) then
      lib.removePrefix homePrefix path
    else
      (lib.updateManyAttrsByPath [
        {
          path = [ (if file then "file" else "directory") ];
          update = lib.removePrefix homePrefix;
        }
      ] path)
  );
in
{
  options = with lib; {
    _ = {
      system.nixos.impermanence = {
        directories = mkOption {
          type = types.listOf (
            types.either (types.pathWith { absolute = null; }) (types.attrsOf types.anything)
          );
          default = [ ];
        };
        files = mkOption {
          type = types.listOf (
            types.either (types.pathWith { absolute = null; }) (types.attrsOf types.anything)
          );
          default = [ ];
        };
      };
    };
  };

  config = lib.mkIf (osCfg.enable && osCfg.home) {
    home.persistence.${osCfg.path} = {
      enable = true;
      allowTrash = true;
      hideMounts = true;
      directories = lib.lists.forEach cfg.directories (removeHomePrefix false);
      files = lib.lists.forEach cfg.files (removeHomePrefix true);
    };

    _ = {
      system.nixos.impermanence = {
        directories = [
          "Documents"
          "Downloads"
          "Music"
          "Pictures"
          "Projects"
          "Videos"

          # Audio
          "${xdgCfg.stateHome}/wireplumber"

          {
            directory = ".gnupg";
            mode = "0700";
          }
          {
            directory = ".ssh";
            mode = "0700";
          }
          {
            directory = "${xdgCfg.dataHome}/keyrings";
            mode = "0700";
          }
        ];
      };
    };
  };
}
