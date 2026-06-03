{
  imports = [
    ../../users/xana/desktop

    ./desktop.nix
    ./disk.nix
    ./network.nix
    ./system.nix
  ];

  system.stateVersion = "26.05";
}
