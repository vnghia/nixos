{
  imports = [
    ../base
  ];

  config = {
    _ = {
      desktop = {
        theming = {
          stylix = {
            enable = true;
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
