{
  imports = [
    ../../nix

    ../common

    ../../packages/shell/zsh
    ../../packages/cli/git

    ./disk.nix
  ];

  system.stateVersion = "26.05";
}
