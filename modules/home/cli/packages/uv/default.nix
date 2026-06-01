{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.cli.packages.uv;
in
{
  options = with lib; {
    cli.packages.uv = {
      enable = mkEnableOption "Uv";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.uv = {
      enable = true;
    };
  };
}
