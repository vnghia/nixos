default:
    just --list

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
        --extra-files {{ prefix }}/etc/hashed-passwords /etc/hashed-passwords
