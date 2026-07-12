default:
    just --list

[group("system")]
system-prepare-secure-boot:
    sudo nix run nixpkgs#sbctl --extra-experimental-features 'nix-command flakes' -- create-keys

[group("system")]
system-verify-secure-boot:
    sudo nix run nixpkgs#sbctl --extra-experimental-features 'nix-command flakes' -- verify

[group("system")]
system-enroll-secure-boot:
    sudo nix run nixpkgs#sbctl --extra-experimental-features 'nix-command flakes' -- enroll-keys --microsoft

[arg("disk")]
[group("filesystem")]
filesystem-cryptenroll-tpm disk="/dev/disk/by-partlabel/luks":
    # 0 	Core System Firmware executable code (aka Firmware)
    # 2 	Extended or pluggable executable code
    # 7 	Secure Boot State
    # 12 	Overridden kernel command line, Credentials
    sudo systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=0+2+7+12 --tpm2-with-pin=yes --wipe-slot=tpm2 {{ disk }}

[arg("disk")]
[group("filesystem")]
filesystem-cryptenroll-fido2 disk="/dev/disk/by-partlabel/luks":
    sudo systemd-cryptenroll --fido2-device=auto --fido2-with-client-pin=yes --fido2-with-user-presence=yes --wipe-slot=fido2 {{ disk }}

[arg("disk")]
[group("filesystem")]
filesystem-cryptenroll-recovery disk="/dev/disk/by-partlabel/luks":
    sudo systemd-cryptenroll --recovery-key {{ disk }}

[arg("disk")]
[group("filesystem")]
filesystem-mount-btrfs disk="/dev/disk/by-label/nixos":
    sudo mkdir -p /btrfs
    sudo mount -o subvol=/ {{ disk }} /btrfs

[arg("user")]
[arg("prefix", long="prefix")]
[group("user")]
user-make-password user prefix="":
    sudo mkdir -p {{ prefix }}/etc/hashed-passwords
    mkpasswd -m sha-512 | sudo tee {{ prefix }}/etc/hashed-passwords/{{ user }}

[arg("name", long="name")]
[group("disko")]
disko-password name="main":
    #! /bin/sh
    echo -n "Enter disk password: "
    read -s password
    echo -n $password > /tmp/disko-{{ name }}-password

[arg("host")]
[arg("path")]
[arg("mode", long="mode")]
[arg("name", long="name")]
[arg("prefix", long="prefix")]
[group("disko")]
disko-install host path name="main" mode="mount" prefix="":
    sudo nix run 'github:nix-community/disko/latest#disko-install' \
        --extra-experimental-features 'nix-command flakes' \
        -- \
        --flake '.#{{ host }}' \
        --disk {{ name }} {{ path }} \
        --mode {{ mode }} \
        --extra-files {{ prefix }}/etc/hashed-passwords {{ prefix }}/etc/hashed-passwords \
        --extra-files /var/lib/sbctl /var/lib/sbctl \
        --extra-files /var/lib/sbctl /persist/var/lib/sbctl
