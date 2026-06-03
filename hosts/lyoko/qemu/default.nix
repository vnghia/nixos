{
  imports = [
    ../configuration.nix

    ./hardware-configuration.nix
  ];

  config = {
    users.users.xana.initialPassword = "test";

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

    _ = {
      desktop = {
        managers = {
          gnome = {
            extensions = {
              night-theme-switcher = {
                key = "nightthemeswitcher";
                config = {
                  time = {
                    manual-schedule = true;
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
