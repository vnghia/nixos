{
  lib,
  config,
  ...
}:
let
  cfg = config._.system.shell.zsh;
in
{
  options = with lib; {
    _ = {
      system.shell.zsh.enable = mkEnableOption "Zsh";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.zsh.enable = true;
  };
}
