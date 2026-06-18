{
  lib,
  config,
  osConfig,
  ...
}:
let
  cfg = config._.cli.programs.shell.zellij;
  shellCfg = osConfig._.system.shell;
  xdgCfg = config.xdg;
in
{
  options = with lib; {
    _ = {
      cli.programs.shell.zellij = {
        enable = mkEnableOption "Zellij";
      };
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

    _ = {
      system.nixos.impermanence.directories = [ "${xdgCfg.cacheHome}/zellij" ];
    };
  };
}
