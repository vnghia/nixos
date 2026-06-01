{
  lib,
  pkgs,
  config,
  osConfig,
  ...
}:
let
  cfg = config.cli.packages.zoxide;
  shellCfg = osConfig.shell;
in
{
  options = with lib; {
    cli.packages.zoxide = {
      enable = mkEnableOption "Zoxide";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.zoxide = {
      enable = true;
      enableZshIntegration = shellCfg.zsh.enable;
      options = [ "--cmd cd" ];
    };
  };
}
