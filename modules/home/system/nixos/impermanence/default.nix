{
  lib,
  config,
  osConfig,
  ...
}:
let
  cfg = config.impermanence;
  osCfg = osConfig.impermanence;
in
{
  options = {
    impermanence = with lib; {
      directories = mkOption {
        type = types.listOf (types.either (types.pathWith { absolute = false; }) types.attrs);
        default = [ ];
      };
      files = mkOption {
        type = types.listOf (types.either (types.pathWith { absolute = false; }) types.attrs);
        default = [ ];
      };
    };
  };

  config = lib.mkIf (osCfg.enable && osCfg.home) {
    home.persistence.${osCfg.path} = {
      directories = cfg.directories;
      files = cfg.files;
    };

    impermanence = {
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

        ".cache"
      ];
    };
  };
}
