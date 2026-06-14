{
  lib,
  config,
  customLib,
  ...
}:
let
  cfg = config._.desktop.programs.alacritty;
in
{
  options = with lib; {
    _ = {
      desktop.programs.alacritty = {
        enable = mkEnableOption "Alacritty";
      }
      // customLib.home.desktop.programs.favorite.mkOption
      // customLib.home.desktop.theming.stylix.mkOption;
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        programs.alacritty = {
          enable = true;
          settings = lib.mkMerge [
            {
              window = {
                blur = true;
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
                  {
                    key = "PageUp";
                    action = "ScrollLineUp";
                  }
                  {
                    key = "PageDown";
                    action = "ScrollLineDown";
                  }
                  {
                    key = "PageUp";
                    mods = "Shift";
                    action = "ScrollPageUp";
                  }
                  {
                    key = "PageDown";
                    mods = "Shift";
                    action = "ScrollPageDown";
                  }
                ];
              };
            }
          ];
        };
      }
      (customLib.home.desktop.programs.favorite.mkConfig "Alacritty.desktop" cfg)
      (customLib.home.desktop.theming.stylix.mkConfig "alacritty" cfg)
      {
        _ = {
          desktop.programs.alacritty.stylix.config = {
            colors.enable = false;
            fonts.enable = true;
            opacity.enable = true;
          };
        };
      }
    ]
  );
}
