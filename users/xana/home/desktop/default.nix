{
  imports = [
    ../base
  ];

  config = {
    _ = {
      desktop = {
        managers = {
          gnome = {
            stylix = {
              enable = true;
            };
          };
        };
        packages = {
          alacritty = {
            enable = true;
            stylix = {
              enable = true;
            };
            favorite = 10;
          };
          nautilus = {
            favorite = 50;
          };
        };
      };
    };
  };
}
