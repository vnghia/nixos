{
  lib,
  pkgs,
  config,
  osConfig,
  ...
}:
let
  cfg = config.desktop.packages.alacritty;
  fontCfg = osConfig.desktop.fonts;
in
{
  options = {
    desktop.packages.alacritty.enable = lib.mkEnableOption "Alacritty";
  };

  config = lib.mkIf cfg.enable {
    programs.alacritty = {
      enable = true;
      settings = lib.mkMerge [
        {
          window = {
            blur = true;
            opacity = 0.65;
            decorations = "none";
            startup_mode = "Maximized";
          };

          colors = {
            draw_bold_text_with_bright_colors = true;
          };

          cursor = {
            style = {
              shape = "Beam";
              blinking = "On";
            };
            unfocused_hollow = false;
          };

          hints = {
            enabled = [
              {
                regex = ''(ipfs:|ipns:|magnet:|mailto:|gemini://|gopher://|https://|http://|news:|file:|git://|ssh:|ftp://)[^\u0000-\u001F\u007F-\u009F<>"\\s{-}\\^⟨⟩`\\\\]+'';
                command = "xdg-open";
                hyperlinks = true;
                post_processing = true;
                persist = false;
                binding = {
                  key = "O";
                  mods = "Control|Shift";
                };
                mouse = {
                  enabled = true;
                };
              }
            ];
          };

          keyboard = {
            bindings = [
              {
                key = "Return";
                mods = "Control|Shift";
                action = "SpawnNewInstance";
              }
              {
                key = "Q";
                mods = "Control|Shift";
                action = "Quit";
              }
            ];
          };
        }
        (lib.mkIf fontCfg.jetbrainsMono.enable {
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
        })
      ];
    };
  };
}
