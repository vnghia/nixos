{
  imports = [
    ../../nix

    ../common

    ../../packages/cli/git

    ./disk.nix
  ];

  system.stateVersion = "26.05";
}
