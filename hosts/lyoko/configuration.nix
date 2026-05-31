{
  imports = [
    ../../nix
    ../../nix/system/impermanence
    ../../nix/system/impermanence/btrfs.nix

    ../../packages/desktop/gnome
    ../../packages/desktop/fonts/jetbrains-mono

    ../../users/xana/desktop

    ../common

    ./disk.nix
  ];

  system.stateVersion = "26.05";
}
