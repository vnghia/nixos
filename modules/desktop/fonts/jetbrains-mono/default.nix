{
  lib,
  pkgs,
  config,
  ...
}:
{
  options = {
    desktop.fonts.enableJetbrainsMono = lib.mkEnableOption "Jetbrains Mono";
  };

  config = lib.mkIf config.desktop.fonts.enableJetbrainsMono {
    fonts.packages = [ pkgs.nerd-fonts.jetbrains-mono ];
  };
}
