{
  imports = [
    ../../packages/desktop/gnome
    ../../packages/desktop/fonts/jetbrains-mono

    ../../users/xana/desktop
  ];

  config = {
    desktop = {
      fonts = {
        enableJetbrainsMono = true;
      };
    };
  };
}
