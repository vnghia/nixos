{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config._.desktop.fonts.jetbrainsMono;
in
{
  options = with lib; {
    _ = {
      desktop.fonts.jetbrainsMono.enable = mkEnableOption "Jetbrains Mono";
    };
  };

  config = lib.mkIf cfg.enable {
    fonts.packages = [ pkgs.nerd-fonts.jetbrains-mono ];
  };
}
