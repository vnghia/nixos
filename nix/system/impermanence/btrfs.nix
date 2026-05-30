{
  lib,
  ...
}:
{
  boot.initrd.postResumeCommands = lib.mkAfter ''
    mkdir -p /btrfs_root

    # We first mount the btrfs root to /btrfs_root
    # so we can manipulate btrfs subvolumes.
    mount -o subvol=/ /dev/disk/by-label/nixos /btrfs_root

    # We then take a snapshot of the current root
    # before recreating a blank root.
    mkdir -p /btrfs_root/@old_roots
    timestamp=$(date --date="@$(stat -c %Y /btrfs_root/@root)" "+%Y-%m-%-d_%H:%M:%S")
    btrfs subvolume snapshot -r /btrfs_root/@root "/btrfs_root/@old_roots/$timestamp"

    delete_subvolume_recursively() {
        IFS=$'\n'
        for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
            delete_subvolume_recursively "/btrfs_root/$i"
        done
        echo "deleting /$1 subvolume..."
        btrfs subvolume delete "$1"
    }

    for i in $(find /btrfs_root/@old_roots/ -maxdepth 1 -mtime +30); do
        delete_subvolume_recursively "$i"
    done

    btrfs subvolume create /btrfs_root/@root

    # Once we're done recreating a blank root.
    # we can unmount /btrfs_root and continue on the boot process.
    umount /btrfs_root
  '';
}
