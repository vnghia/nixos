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
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = lib.mkDefault "/dev/nvme0n1";
        content = {
          type = "gpt";
          partitions = {
            esp = {
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
                      mountOptions = [ "subvol=root" ] ++ btrfsOptions;
                    };
                    "@home" = {
                      mountpoint = "/home";
                      mountOptions = [ "subvol=home" ] ++ btrfsOptions;
                    };
                    "@nix" = {
                      mountpoint = "/nix";
                      mountOptions = [ "subvol=nix" ] ++ btrfsOptions;
                    };
                    "@persistent" = {
                      mountpoint = "/persistent";
                      mountOptions = [ "subvol=persistent" ] ++ btrfsOptions;
                    };
                    "@log" = {
                      mountpoint = "/var/log";
                      mountOptions = [ "subvol=log" ] ++ btrfsOptions;
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

  fileSystems."/persist".neededForBoot = true;
  fileSystems."/var/log".neededForBoot = true;
}
