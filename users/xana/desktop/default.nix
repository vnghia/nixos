{
  imports = [
    ../base
  ];

  config = {
    user = {
      home = import ../home/desktop;
    };
  };
}
