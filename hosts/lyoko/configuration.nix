{
  imports = [
    ../../nix
    ../../nix/system/impermanence
    ../../nix/system/impermanence/btrfs.nix

    ../common

    ./desktop.nix
    ./disk.nix
  ];

  system.stateVersion = "26.05";
}
