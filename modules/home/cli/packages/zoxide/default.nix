{
  lib,
  pkgs,
  config,
  osConfig,
  ...
}:
let
  cfg = config._.cli.packages.zoxide;
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
      options = [ "--cmd cd" ];
    };

    _ = {
      system.nixos.impermanence.directories = [ "${xdgCfg.dataHome}/zoxide" ];
    };
  };
}
