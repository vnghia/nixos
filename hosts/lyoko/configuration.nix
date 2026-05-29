{
  imports = [
    ../../nix

    ../common

    ./hardware-configuration.nix
    ./disk.nix
  ];

  system.stateVersion = "26.05";
}
