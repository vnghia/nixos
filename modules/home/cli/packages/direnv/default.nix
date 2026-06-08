{
  lib,
  config,
  ...
}:
let
  cfg = config._.cli.packages.direnv;
in
{
  options = with lib; {
    _ = {
      cli.packages.direnv = {
        enable = mkEnableOption "Direnv";
        nix = mkEnableOption "Nix";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs = {
      direnv = {
        enable = true;
        nix-direnv.enable = cfg.nix;
        config = {
          global = {
            load_dotenv = true;
            strict_env = true;
          };
        };
      };
    };

    _ = {
      system.nixos.impermanence.directories = [ ".local/share/direnv" ];
    };
  };
}
