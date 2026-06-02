{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config._.cli.packages.vim;
in
{
  options = with lib; {
    _ = {
      cli.packages.vim = {
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
