{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config._.cli.programs.development.nixfmt;
in
{
  options = with lib; {
    _ = {
      cli.programs.development.nixfmt = {
        enable = mkEnableOption "Nixfmt";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.nixfmt ];
  };
}
