{
  lib,
  config,
  ...
}:
let
  cfg = config._.cli.packages.jq;
in
{
  options = with lib; {
    _ = {
      cli.packages.jq = {
        enable = mkEnableOption "Jq";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.jq = {
      enable = true;
    };
  };
}
