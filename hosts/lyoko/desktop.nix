{
  config = {
    desktop = {
      fonts = {
        enableJetbrainsMono = true;
      };
      environment = {
        gnome = {
          enable = true;
          extensions = {
            hide-top-bar = {
              key = "hidetopbar";
              config = {
                enable-active-window = false;
                enable-intellihide = false;
                mouse-sensitive = true;
              };
            };
          };
        };
      };
    };
  };
}
