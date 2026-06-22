{
  lib,
  config,
  osConfig,
  ...
}:
let
  cfg = config._.cli.programs.terminal.zellij;
  shellCfg = osConfig._.shell;
  xdgCfg = config.xdg;
in
{
  options = with lib; {
    _ = {
      cli.programs.terminal.zellij = {
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
      nixos.impermanence.directories = [
        "${xdgCfg.cacheHome}/zellij"
      ];
    };
  };
}
