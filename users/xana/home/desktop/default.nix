{
  imports = [
    ../base
  ];

  config = {
    _ = {
      desktop = {
        packages = {
          alacritty = {
            enable = true;
          };
        };
      };
    };
  };
}
