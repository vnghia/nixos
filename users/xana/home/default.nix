{ pkgs, ... }:
{
  home = {
    username = "xana";
    homeDirectory = "/home/xana";
  };

  programs.home-manager.enable = true;

  home.stateVersion = "26.05"
}
