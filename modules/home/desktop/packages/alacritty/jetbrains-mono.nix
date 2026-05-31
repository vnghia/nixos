{
  lib,
  pkgs,
  osConfig,
  ...
}:
let
  fontConfig = osConfig.desktop.fonts;
in
{
  programs.alacritty = lib.mkIf fontConfig.enableJetbrainsMono {
    settings = {
      font = {
        size = 12;
        builtin_box_drawing = false;

        normal = {
          family = "JetBrainsMono Nerd Font";
          style = "Regular";
        };

        bold = {
          family = "JetBrainsMono Nerd Font";
          style = "Bold";
        };

        italic = {
          family = "JetBrainsMono Nerd Font";
          style = "Italic";
        };

        bold_italic = {
          family = "JetBrainsMono Nerd Font";
          style = "Bold Italic";
        };
      };
    };
  };
}
