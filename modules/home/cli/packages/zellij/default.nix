{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.cli.packages.zellij;
in
{
  options = with lib; {
    cli.packages.zellij = {
      enable = mkEnableOption "Zellij";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.zellij = {
      enable = true;
      settings = {
        on_force_close = "quit";

        pane_frames = false;
      };
    };
  };
}
