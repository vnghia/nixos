default:
    just --list

disko-install host name path:
    sudo nix run 'github:nix-community/disko/latest#disko-install' \
        --extra-experimental-features 'nix-command flakes' \
        -- \
        --flake '.#{{ host }}' \
        --disk {{ name }} {{ path }}
