{
  imports = [
    ../../users/xana/desktop
  ];

  config = {
    desktop = {
      fonts = {
        enableJetbrainsMono = true;
      };
      gnome = {
        enable = true;
        extensions = {
          hideTopBar = {
            enable = true;
          };
        };
      };
    };
  };
}
