{
  imports = [
    ../../nix

    ../common

    ../../packages/shell/zsh
    ../../packages/cli/git
    ../../packages/desktop

    ./disk.nix
  ];

  system.stateVersion = "26.05";
}
