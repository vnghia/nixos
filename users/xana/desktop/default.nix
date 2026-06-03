{
  imports = [
    ../base
  ];

  config = {
    _ = {
      user = {
        home = import ../home/desktop;
      };
    };
  };
}
