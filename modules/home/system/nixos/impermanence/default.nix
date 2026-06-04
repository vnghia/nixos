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
    path: if (lib.strings.isString path) then lib.strings.removePrefix homePrefix path else path
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
      directories = lib.lists.forEach cfg.directories removeHomePrefix;
      files = lib.lists.forEach cfg.files removeHomePrefix;
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

          {
            directory = ".gnupg";
            mode = "0700";
          }
          {
            directory = ".ssh";
            mode = "0700";
          }
          {
            directory = ".local/share/keyrings";
            mode = "0700";
          }

          # Home-manager
          "${xdgCfg.stateHome}/home-manager"
          "${xdgCfg.stateHome}/nix"
        ];
      };
    };
  };
}
