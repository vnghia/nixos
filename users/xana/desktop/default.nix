{
  imports = [
    ../base

    ../../../packages/desktop
  ];

  home-manager = {
    users.xana = import ../home/desktop;
  };
}
