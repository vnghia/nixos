{
  lib,
  pkgs,
  config,
  osConfig,
  ...
}:
let
  cfg = config._.cli.packages.zellij;
  xdgCfg = config.xdg;
in
{
  options = with lib; {
    _ = {
      cli.packages.zellij = {
        enable = mkEnableOption "Zellij";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.zellij = {
      enable = true;
      settings = {
        on_force_close = "quit";
        show_startup_tips = false;

        pane_frames = false;
      };
    };

    _ = {
      system.nixos.impermanence.directories = [ "${xdgCfg.cacheHome}/zellij" ];
    };
  };
}
