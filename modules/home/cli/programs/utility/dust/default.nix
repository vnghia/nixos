{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config._.cli.programs.utility.dust;
in
{
  options = with lib; {
    _ = {
      cli.programs.utility.dust = {
        enable = mkEnableOption "Dust";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      dust
    ];
  };
}
