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
  config = {
    stylix = {
      base16Scheme = "${pkgs.base16-schemes}/share/themes/one-light.yaml";

      fonts = {
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
        sizes = {
          applications = 10;
          desktop = 10;
          popups = 10;
          terminal = 12;
        };
      };

      opacity = {
        terminal = 0.65;
      };
    };
  };
}
