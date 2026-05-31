{
  imports = [
    ../base
  ];

  home-manager = {
    users.xana = import ../home/desktop;
  };
}
