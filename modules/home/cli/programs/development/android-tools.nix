{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config._.cli.programs.development.android-tools;
  homeCfg = config.home;
in
{
  options = with lib; {
    _ = {
      cli.programs.development.android-tools = {
        enable = mkEnableOption "Android tools";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      android-tools
    ];

    _ = {
      nixos.impermanence.directories = {
        "${homeCfg.homeDirectory}/.android" = { };
      };
    };
  };
}
