{
  lib,
  config,
  ...
}:
let
  cfg = config._.cli.programs.jq;
in
{
  options = with lib; {
    _ = {
      cli.programs.jq = {
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
