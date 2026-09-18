{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config._.cli.programs.development.cachix;
in
{
  options = with lib; {
    _ = {
      cli.programs.development.cachix = {
        enable = mkEnableOption "Cachix";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      cachix
    ];
  };
}
