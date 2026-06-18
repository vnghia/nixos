{
  lib,
  config,
  ...
}:
let
  cfg = config._.cli.programs.utility.jq;
in
{
  options = with lib; {
    _ = {
      cli.programs.utility.jq = {
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
