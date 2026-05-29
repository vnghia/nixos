{
  imports = [
    ../../common

    ./hardware-configuration.nix
    ./disk.nix
  ];

  networking.hostName = "lyoko";
  nixpkgs.hostPlatform = "x86_64-linux";

  users.users = {
    alice = {
      initialPassword = "test";
      isNormalUser = true;
      extraGroups = [ "wheel" ];
    };
  };

  system.stateVersion = "26.05";
}
