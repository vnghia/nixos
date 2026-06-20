{
  lib,
  config,
  ...
}:
let
  cfg = config._.cli.programs.terminal.zoxide;
  xdgCfg = config.xdg;
in
{
  options = with lib; {
    _ = {
      cli.programs.terminal.zoxide = {
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
