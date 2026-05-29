{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:
{
  imports = [
    ./boot.nix
    ./host.nix
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  nix = {
    settings = {
      experimental-features = "nix-command flakes";
      flake-registry = "";
    };
    channel.enable = false;
  };

  networking.hostName = "lyoko";

  users.users = {
    alice = {
      initialPassword = "test";
      isNormalUser = true;
      extraGroups = [ "wheel" ];
    };
  };

  system.stateVersion = "26.05";
}
