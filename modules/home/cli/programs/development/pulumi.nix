{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config._.cli.programs.development.pulumi;
  homeCfg = config.home;
in
{
  options = with lib; {
    _ = {
      cli.programs.development.pulumi = {
        enable = mkEnableOption "Pulumi";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.pulumi ];

    _ = {
      nixos.impermanence.directories = {
        "${homeCfg.homeDirectory}/.pulumi" = {
          restic = false;
        };
      };
    };
  };
}
