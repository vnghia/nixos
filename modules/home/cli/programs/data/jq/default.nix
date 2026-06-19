{
  lib,
  config,
  ...
}:
let
  cfg = config._.cli.programs.data.jq;
in
{
  options = with lib; {
    _ = {
      cli.programs.data.jq = {
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
