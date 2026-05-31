{
  imports = [
    ../base
  ];

  config = {
    desktop = {
      packages = {
        alacritty = {
          enable = true;
        };
      };
    };
  };
}
