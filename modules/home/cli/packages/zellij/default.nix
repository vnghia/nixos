{
  lib,
  pkgs,
  config,
  osConfig,
  ...
}:
let
  cfg = config.cli.packages.zellij;
  shellCfg = osConfig.shell;
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
      enableZshIntegration = shellCfg.zsh.enable;
      settings = {
        on_force_close = "quit";
        show_startup_tips = false;

        pane_frames = false;
      };
    };
  };
}
