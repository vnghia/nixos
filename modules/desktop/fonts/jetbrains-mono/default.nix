{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.desktop.fonts.jetbrainsMono;
in
{
  options = {
    desktop.fonts.jetbrainsMono.enable = lib.mkEnableOption "Jetbrains Mono";
  };

  config = lib.mkIf cfg.enable {
    fonts.packages = [ pkgs.nerd-fonts.jetbrains-mono ];
  };
}
