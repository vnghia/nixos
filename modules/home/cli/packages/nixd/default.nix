{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config._.cli.packages.nixd;
in
{
  options = with lib; {
    _ = {
      cli.packages.nixd = {
        enable = mkEnableOption "Nixd";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.nixd ];
  };
}
