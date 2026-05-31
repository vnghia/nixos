{
  imports = [
    ../../nix

    ../common

    ./desktop.nix
    ./disk.nix
  ];

  system.stateVersion = "26.05";
}
