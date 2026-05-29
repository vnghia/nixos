{
  imports = [
    ../configuration.nix

    ../../../users/alice.nix

    ./hardware-configuration.nix
  ];

  disko.devices = {
    disk = {
      main = {
        imageSize = "50G";
        device = "/dev/vda";
        content = {
          partitions = {
            luks = {
              content = {
                passwordFile = "/tmp/password";
                content = {
                  subvolumes = {
                    "@swap" = {
                      swap.swapfile.size = "8G";
                    };
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
