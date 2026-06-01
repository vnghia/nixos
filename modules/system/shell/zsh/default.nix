{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.shell.zsh;
  userCfg = config.user;
in
{
  options = {
    shell.zsh.enable = lib.mkEnableOption "Zsh";
  };

  config = lib.mkIf (cfg.enable || userCfg.shell == "zsh") {
    programs.zsh.enable = true;
  };
}
