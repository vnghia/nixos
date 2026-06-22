{
  imports = [
    ./boot.nix
    ./desktop.nix
    ./disk.nix
    ./hardware.nix
    ./linux.nix
    ./network.nix
    ./nixos.nix
    ./programs.nix
    ./security.nix
    ./virtualisation.nix
  ];

  system.stateVersion = "26.05";
}
