{
  lib,
  config,
  ...
}:
let
  cfg = config._.cli.programs.development.vim;
in
{
  options = with lib; {
    _ = {
      cli.programs.development.vim = {
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
