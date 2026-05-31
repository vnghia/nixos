{
  programs.alacritty = {
    enable = true;
    settings = {
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
          {
            regex = ''[^ ]+\\.(c|h|cpp|hpp|cxx|hxx|cc|hh|cmake|html|css|csv|cu|diff|patch|json|json5|jsx|js|ts|proto|py|r|rmd|rs|.sh|.bash|.zsh|.tex|.aux|.bib|.toml|.txt|.xml|.yml|.yaml):\\d+:\\d+'';
            command = {
              program = "code";
              args = [ "--goto" ];
            };
            hyperlinks = true;
            post_processing = false;
            persist = false;
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
    };
  };
}
