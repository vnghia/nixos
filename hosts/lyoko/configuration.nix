{
  imports = [
    ../../users/xana/desktop

    ../common

    ./desktop.nix
    ./disk.nix
    ./system.nix
  ];

  system.stateVersion = "26.05";
}
