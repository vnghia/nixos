{
  imports = [
    ../configuration.nix

    ../../../users/alice.nix

    ./hardware-configuration.nix
  ];

  disko.devices = {
    disk = {
      main = {
        content = {
          partitions = {
            luks = {
              passwordFile = "/tmp/password";
            };
          };
        };
      };
    };
  };
}
