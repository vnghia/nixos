{
  lib,
  config,
  ...
}:
let
  cfg = config._.cli.programs.data.rclone;
  xdgCfg = config.xdg;
in
{
  options = with lib; {
    _ = {
      cli.programs.data.rclone = {
        enable = mkEnableOption "Rclone";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.rclone = {
      enable = true;
    };

    _ = {
      nixos.impermanence.directories = {
        "${xdgCfg.configHome}/rclone" = {
          mode = "0700";
        };
      };
    };
  };
}
