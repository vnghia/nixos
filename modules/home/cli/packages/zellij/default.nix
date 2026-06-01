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
  userCfg = osConfig.user;
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
      enableZshIntegration = shellCfg.zsh.enable || userCfg.shell == "zsh";
      settings = {
        on_force_close = "quit";

        pane_frames = false;
      };
    };
  };
}
