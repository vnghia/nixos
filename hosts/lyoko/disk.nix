{
  lib,
  ...
}:
let
  btrfsOptions = [
    "compress=zstd"
    "noatime"
    "ssd"
  ];
in
{
  config = {
    system = {
      filesystem.root.type = "btrfs";

      nixos.impermanence = {
        enable = true;
        home = true;
        path = "/persistent";
      };
    };

    disko.devices = {
      disk = {
        main = {
          type = "disk";
          device = lib.mkDefault "/dev/nvme0n1";
          content = {
            type = "gpt";
            partitions = {
              esp = {
                label = "boot";
                name = "esp";
                size = "1G";
                type = "EF00";
                content = {
                  type = "filesystem";
                  format = "vfat";
                  mountpoint = "/boot";
                  mountOptions = [ "umask=0077" ];
                };
              };
              luks = {
                label = "luks";
                size = "100%";
                content = {
                  type = "luks";
                  name = "cryptroot";
                  extraFormatArgs = [
                    "--type luks2"
                    "--pbkdf argon2id"
                  ];
                  settings = {
                    allowDiscards = true;
                    bypassWorkqueues = true;
                  };
                  content = {
                    type = "btrfs";
                    extraArgs = [
                      "-L"
                      "nixos"
                      "-f"
                    ];
                    subvolumes = {
                      "@root" = {
                        mountpoint = "/";
                        mountOptions = btrfsOptions;
                      };
                      "@home" = {
                        mountpoint = "/home";
                        mountOptions = btrfsOptions;
                      };
                      "@nix" = {
                        mountpoint = "/nix";
                        mountOptions = btrfsOptions;
                      };
                      "@persistent" = {
                        mountpoint = "/persistent";
                        mountOptions = btrfsOptions;
                      };
                      "@swap" = {
                        mountpoint = "/swap";
                        swap.swapfile.size = lib.mkDefault "64G";
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
