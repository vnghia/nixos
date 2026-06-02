{
  lib,
  config,
  osConfig,
  ...
}:
let
  cfg = config._.system.nixos.impermanence;
  osCfg = osConfig._.system.nixos.impermanence;
in
{
  options = with lib; {
    _ = {
      system.nixos.impermanence = {
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
  };

  config = lib.mkIf (osCfg.enable && osCfg.home) {
    home.persistence.${osCfg.path} = {
      directories = cfg.directories;
      files = cfg.files;
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

          ".cache"
        ];
      };
    };
  };
}
