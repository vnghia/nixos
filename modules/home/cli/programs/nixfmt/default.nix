{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config._.cli.programs.nixfmt;
in
{
  options = with lib; {
    _ = {
      cli.programs.nixfmt = {
        enable = mkEnableOption "Nixfmt";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.nixfmt ];
  };
}
