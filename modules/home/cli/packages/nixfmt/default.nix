{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config._.cli.packages.nixfmt;
in
{
  options = with lib; {
    _ = {
      cli.packages.nixfmt = {
        enable = mkEnableOption "Nixfmt";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.nixfmt ];
  };
}
