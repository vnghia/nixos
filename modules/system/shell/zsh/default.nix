{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config._.shell.zsh;
in
{
  options = with lib; {
    _ = {
      shell.zsh.enable = mkEnableOption "Zsh";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.zsh.enable = true;
  };
}
