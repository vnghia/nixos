{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.cli.packages.vim;
in
{
  options = with lib; {
    cli.packages.vim = {
      enable = mkEnableOption "Vim";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.vim = {
      enable = true;
      defaultEditor = true;
    };
  };
}
