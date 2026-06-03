{
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
            gvfs = true;
          };
        };
        packages = {
          nautilus = {
            enable = true;
          };
        };
        theming = {
          stylix = {
            image = ../../wallpapers/kde-breeze/light.png;
          };
        };
      };
    };
  };
}
