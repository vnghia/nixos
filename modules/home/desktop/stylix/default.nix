{
  lib,
  config,
  pkgs,
  ...
}:
{
  config = {
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
