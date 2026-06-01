{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.shell.zsh;
in
{
  options = {
    shell.zsh.enable = lib.mkEnableOption "Zsh";
  };

  config = lib.mkIf cfg.enable {
    programs.zsh.enable = true;
  };
}
