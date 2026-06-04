{
  imports = [
    ./desktop.nix
    ./disk.nix
    ./network.nix
    ./system.nix
  ];

  system.stateVersion = "26.05";
}
