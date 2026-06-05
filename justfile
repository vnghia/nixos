default:
    just --list

[arg("name", long="name")]
[group("disko")]
disko-password password name="main":
    echo -n '{{ password }}' > /tmp/disko-{{ name }}-password

[arg("host")]
[arg("path")]
[arg("mode", long="mode")]
[arg("name", long="name")]
[group("disko")]
disko-install host path name="main" mode="mount":
    sudo nix run 'github:nix-community/disko/latest#disko-install' \
        --extra-experimental-features 'nix-command flakes' \
        -- \
        --flake '.#{{ host }}' \
        --disk {{ name }} {{ path }} \
        --mode {{ mode }}
