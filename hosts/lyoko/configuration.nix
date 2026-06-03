{
  imports = [
    ../../users/xana/desktop

    ./disk.nix
    ./network.nix
    ./system.nix
  ];

  system.stateVersion = "26.05";
}
