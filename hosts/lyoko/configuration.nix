{
  imports = [
    ../../nix
    ../../nix/system/impermanence
    ../../nix/system/impermanence/btrfs.nix

    ../../packages/desktop/gnome

    ../../users/xana/desktop

    ../common

    ./disk.nix
  ];

  system.stateVersion = "26.05";
}
