{
  lib,
  config,
  customLib,
  ...
}:
let
  cfg = config._.nixos.impermanence;
  filesystemCfg = config._.filesystem;
  timezoneFile = "${cfg.path}/timezone";
in
{
  options = with lib; {
    _ = {
      nixos.impermanence = {
        enable = mkEnableOption "Impermanence";
        home = mkEnableOption "Impermanence home";
        path = mkOption { type = types.path; };
        directories = mkOption {
          type = types.attrsOf types.anything;
          default = { };
        };
        files = mkOption {
          type = types.attrsOf types.anything;
          default = { };
        };
        normalizedDirectories = mkOption {
          type = types.attrsOf types.anything;
          readOnly = true;
        };
        normalizedFiles = mkOption {
          type = types.attrsOf types.anything;
          readOnly = true;
        };
      };
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        environment.persistence.${cfg.path} = {
          enable = true;
          allowTrash = true;
          hideMounts = true;
          directories = lib.mapAttrsToList (customLib.nixos.impermanence.mkConfig false) cfg.normalizedDirectories;
          files = lib.mapAttrsToList (customLib.nixos.impermanence.mkConfig true) cfg.normalizedFiles;
        };

        _ = {
          nixos.impermanence = {
            directories = {
              # System state
              "/var/log" = { };
              "/var/lib/nixos" = { };
              "/var/lib/systemd/coredump" = { };
              "/var/lib/systemd/timers" = { };
              "/var/lib/systemd/rfkill" = { };
              "/var/lib/systemd/backlight" = { };
              "/var/lib/colord" = {
                user = "colord";
                group = "colord";
                mode = "u=rwx,g=rx,o=";
              };

              # Auth and SSH
              "/etc/ssh" = { };

              # Hardware state
              "/var/lib/bluetooth" = { };
              "/var/lib/upower" = { };
              "/var/lib/alsa" = { };
              "/var/lib/power-profiles-daemon" = { };
            };
            files = {
              # Machine id
              "/etc/machine-id" = { };
              "/var/lib/dbus/machine-id" = { };
              # TODO: Remove this after https://github.com/NixOS/nixpkgs/issues/501336
              "/var/lib/systemd/credential.secret" = { };
            };
          };

          nixos.impermanence = {
            normalizedDirectories = customLib.nixos.impermanence.mkNormalizedPaths (path: path) cfg.directories;
            normalizedFiles = customLib.nixos.impermanence.mkNormalizedPaths (path: path) cfg.files;
          };

          users.hashedPasswordDirectory = "${cfg.path}/etc/hashed-passwords";
        };

        fileSystems.${cfg.path}.neededForBoot = true;

        fileSystems."/".neededForBoot = true;
        fileSystems."/home".neededForBoot = cfg.home;

        virtualisation.vmVariantWithDisko = {
          virtualisation.fileSystems.${cfg.path}.neededForBoot = true;

          virtualisation.fileSystems."/".neededForBoot = true;
          virtualisation.fileSystems."/home".neededForBoot = cfg.home;
        };

        systemd.services.set-timezone = {
          enable = true;
          description = "Set system timezone to ${timezoneFile}";
          wantedBy = [ "multi-user.target" ];
          serviceConfig.Type = "oneshot";
          script = ''
            if [ -e "${timezoneFile}" ]; then
              timezone=$(cat ${timezoneFile})
              echo "setting timezone to $timezone"
              timedatectl set-timezone $timezone
            fi
          '';
        };
      }
      (lib.mkIf (filesystemCfg.root.type == "btrfs") {
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

            timestamp=$(date --date="@$(stat -c %Y /btrfs/@root)" "+%Y-%m-%-d-%H-%M-%S")

            # We then take a snapshot of the current root
            # before recreating a blank root.
            mkdir -p /btrfs/@snapshots/@root
            btrfs subvolume snapshot -r /btrfs/@root "/btrfs/@snapshots/@root/$timestamp"

            ${lib.optionalString cfg.home ''
              # Also do the same thing for the current home
              mkdir -p /btrfs/@snapshots/@home
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
