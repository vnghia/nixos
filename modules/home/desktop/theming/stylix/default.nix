{
  lib,
  config,
  osConfig,
  pkgs,
  ...
}:
let
  osCfg = osConfig._.desktop.theming.stylix;
in
{
  config = lib.mkIf osCfg.enable {
    stylix.fonts = {
      serif = {
        package = pkgs.ubuntu-sans;
        name = "Ubuntu";
      };

      sansSerif = {
        package = pkgs.ubuntu-sans;
        name = "Ubuntu";
      };

      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font";
      };

      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };
    };
  };
}
