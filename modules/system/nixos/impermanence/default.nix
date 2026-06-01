{
  lib,
  config,
  ...
}:
let
  cfg = config.impermanence;
in
{
  options = {
    impermanence = with lib; {
      enable = mkEnableOption "Impermanence";
      home = mkEnableOption "Impermanence home";
      path = mkOption { type = types.path; };
      type = mkOption { type = types.enum [ "btrfs" ]; };
      directories = mkOption {
        type = types.listOf (types.either types.path types.attrs);
        default = [ ];
      };
      files = mkOption {
        type = types.listOf (types.either types.path types.attrs);
        default = [ ];
      };
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        environment.persistence.${cfg.path} = {
          hideMounts = true;
          directories = cfg.directories;
          files = cfg.files;
        };

        impermanence = {
          directories = [
            # System state
            "/var/log"
            "/var/lib/nixos"
            "/var/lib/systemd/coredump"
            "/var/lib/systemd/timers"
            "/var/lib/systemd/rfkill"
            "/var/lib/systemd/backlight"

            # Auth and SSH
            "/etc/ssh"

            # Hardware state
            "/var/lib/bluetooth"
            "/var/lib/upower"
            "/var/lib/alsa"
          ];

          files = [
            "/etc/machine-id"
            "/var/lib/dbus/machine-id"
          ];
        };

        fileSystems."/".neededForBoot = true;
        fileSystems.${cfg.path}.neededForBoot = true;
        fileSystems."/home".neededForBoot = cfg.home;

        virtualisation.vmVariantWithDisko = {
          virtualisation.fileSystems."/".neededForBoot = true;
          virtualisation.fileSystems.${cfg.path}.neededForBoot = true;
          virtualisation.fileSystems."/home".neededForBoot = cfg.home;
        };
      }
      (lib.mkIf (cfg.type == "btrfs") {
        boot.initrd.systemd.services.btrfs-impermanence = {
          description = "Manage btrfs subvolumes impermanence";
          wantedBy = [ "initrd.target" ];
          # make sure it's done after encryption
          # i.e. LUKS/TPM process
          after = [ "systemd-cryptsetup@cryptroot.service" ];
          # mount the root fs before clearing
          before = [ "sysroot.mount" ];
          unitConfig.DefaultDependencies = "no";
          serviceConfig.Type = "oneshot";
          script = ''
            mkdir -p /btrfs

            # We first mount the btrfs root to /btrfs
            # so we can manipulate btrfs subvolumes.
            mount -o subvol=/ /dev/mapper/cryptroot /btrfs

            # We then take a snapshot of the current root
            # before recreating a blank root.
            mkdir -p /btrfs/@snapshots/@root
            timestamp=$(date --date="@$(stat -c %Y /btrfs/@root)" "+%Y-%m-%-d-%H-%M-%S")
            btrfs subvolume snapshot -r /btrfs/@root "/btrfs/@snapshots/@root/$timestamp"


            ${lib.optionalString cfg.home ''
              # Also do the same thing for the current home
              mkdir -p /btrfs/@snapshots/@home
              timestamp=$(date --date="@$(stat -c %Y /btrfs/@home)" "+%Y-%m-%-d-%H-%M-%S")
              btrfs subvolume snapshot -r /btrfs/@home "/btrfs/@snapshots/@home/$timestamp"
            ''}

            delete_subvolume_recursively() {
                IFS=$'\n'
                for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
                    delete_subvolume_recursively "/btrfs/$i"
                done
                echo "deleting $1 subvolume..."
                btrfs subvolume delete "$1"
            }

            for i in $(find /btrfs/@snapshots/@root/ -maxdepth 1 -mtime +30); do
                delete_subvolume_recursively "$i"
            done

            delete_subvolume_recursively /btrfs/@root
            btrfs subvolume create /btrfs/@root

            ${lib.optionalString cfg.home ''
              for i in $(find /btrfs/@snapshots/@home/ -maxdepth 1 -mtime +30); do
                  delete_subvolume_recursively "$i"
              done

              delete_subvolume_recursively /btrfs/@home
              btrfs subvolume create /btrfs/@home
            ''}

            # Once we're done recreating blank subvolumes.
            # we can unmount /btrfs and continue on the boot process.
            umount /btrfs
          '';
        };
      })
    ]
  );
}
