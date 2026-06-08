{
  ...
}:
{
  imports = [
    ../configuration.nix

    ./hardware-configuration.nix
  ];

  config = {
    disko.memSize = 16;

    disko.devices = {
      disk = {
        main = {
          imageSize = "50G";
          device = "/dev/vda";
          content = {
            partitions = {
              luks = {
                content = {
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
  };
}
