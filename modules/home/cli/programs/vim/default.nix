{
  lib,
  config,
  ...
}:
let
  cfg = config._.cli.programs.vim;
in
{
  options = with lib; {
    _ = {
      cli.programs.vim = {
        enable = mkEnableOption "Vim";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.vim = {
      enable = true;
      defaultEditor = true;
    };
  };
}
