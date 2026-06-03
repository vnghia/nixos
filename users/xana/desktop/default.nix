{
  imports = [
    ../base
  ];

  config = {
    _ = {
      desktop = {
        fonts = {
          jetbrainsMono = {
            enable = true;
          };
        };
        managers = {
          gnome = {
            enable = true;
          };
        };
        theming = {
          stylix = {
            image = ../../../wallpapers/kde-breeze/light.png;
          };
        };
      };
      user = {
        home = import ../home/desktop;
      };
    };
  };
}
