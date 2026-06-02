{
  lib,
  pkgs,
  config,
  osConfig,
  ...
}:
let
  cfg = config._.cli.packages.zoxide;
  shellCfg = osConfig._.shell;
  xdgCfg = config.xdg;
in
{
  options = with lib; {
    _ = {
      cli.packages.zoxide = {
        enable = mkEnableOption "Zoxide";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.zoxide = {
      enable = true;
      enableZshIntegration = shellCfg.zsh.enable;
      options = [ "--cmd cd" ];
    };

    _ = {
      system.nixos.impermanence.directories = [ "${xdgCfg.dataHome}/zoxide" ];
    };
  };
}
