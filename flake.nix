{
  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-26.05";
    };

    nixpkgs-unstable = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };

    nixpkgs-cake-wallet = {
      url = "github:iamanaws/nixpkgs/pkgs/cake-wallet";
    };

    nixos-hardware = {
      url = "github:NixOS/nixos-hardware";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko/v1.13.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence = {
      url = "github:nix-community/impermanence";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    stylix = {
      url = "github:nix-community/stylix/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.1.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake/beta";
      inputs = {
        nixpkgs.follows = "nixpkgs-unstable";
        home-manager.follows = "home-manager";
      };
    };

    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };

    nix-cachyos-kernel = {
      url = "github:xddxdd/nix-cachyos-kernel/release";
    };

    jail-nix = {
      # Use upstream after https://codeberg.org/alexdavid/jail.nix/issues/4
      url = "git+https://codeberg.org/MohrJonas/jail.nix?ref=main";
    };
  };

  nixConfig = {
    extra-substituters = "https://cache.lantian.pub/lantian";
    extra-trusted-public-keys = "lantian:WVGO7vsRMSEN+h7Lp7kv6SAmrkEXgUGbbXm7jMDjBuQ=";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      nixpkgs-cake-wallet,
      home-manager,
      disko,
      impermanence,
      stylix,
      lanzaboote,
      nix-vscode-extensions,
      sops-nix,
      nix-cachyos-kernel,
      jail-nix,
      ...
    }@inputs:
    let
      stateVersion = "26.05";

      lib = nixpkgs.lib;
      customLib = (import ./lib) {
        inherit lib;
      };

      unstablePackages = [
        # development
        "vscodium"
        "uv"

        # game
        "dwproton-bin"
        "proton-ge-bin"
        "steam"
        "steam-unwrapped"

        # internet
        "mullvad"
        "mullvad-vpn"
      ];

      unfreePackages = [
        "obsidian"
        "steam"
        "steam-unwrapped"
      ];

      allowUnfreePredicate = package: builtins.elem (lib.getName package) unfreePackages;

      hosts = {
        lyoko = {
          platform = "x86_64-linux";
          flavors = [
            "host"
            "qemu"
          ];
          users = {
            xana = "desktop";
          };
        };
      };

      mkHostName = name: flavor: "${name}${lib.optionalString (flavor != "host") "-${flavor}"}";

      outputs = lib.concatMapAttrs (
        name: value:
        lib.mergeAttrsList (
          lib.lists.forEach value.flavors (
            flavor:
            let
              pkgs = import nixpkgs { system = value.platform; };
              jail = jail-nix.lib.init pkgs;

              unstable-pkgs = import nixpkgs-unstable {
                system = value.platform;
                config = { inherit allowUnfreePredicate; };
              };
              cake-wallet-pkgs = import nixpkgs-cake-wallet {
                system = value.platform;
                config = { inherit allowUnfreePredicate; };
              };

              hostName = mkHostName name flavor;
              hostSystem = lib.nixosSystem {
                specialArgs = {
                  inherit inputs;
                  inherit customLib;
                  inherit jail;
                  secrets =
                    customLib.nixos.sops.mkSecrets pkgs "host-build-secrets-${name}"
                      ./secrets/hosts/${name}/build/secrets.yaml;
                };
                modules = [
                  home-manager.nixosModules.home-manager
                  disko.nixosModules.disko
                  impermanence.nixosModules.impermanence
                  stylix.nixosModules.stylix
                  lanzaboote.nixosModules.lanzaboote
                  sops-nix.nixosModules.sops

                  {
                    nixpkgs = {
                      hostPlatform = value.platform;
                      config = { inherit allowUnfreePredicate; };
                      overlays = [
                        (customLib.nixos.overlay.mkPackageOverlay unstable-pkgs unstablePackages)
                        (customLib.nixos.overlay.mkPackageOverlay cake-wallet-pkgs [ "cake-wallet" ])
                      ]
                      ++ [
                        nix-vscode-extensions.overlays.default
                        nix-cachyos-kernel.overlays.pinned
                      ];
                    };
                  }

                  ./modules

                  ./hosts/${name}/${flavor}
                  {
                    networking.hostName = hostName;
                    sops.defaultSopsFile = ./secrets/hosts/${name}/run/secrets.yaml;
                  }
                  {
                    imports = lib.mapAttrsToList (
                      userName: userFlavor: ./users/${userName} + "/${userFlavor}.nix"
                    ) value.users;
                  }
                ];
              };
            in
            {
              ${hostName} = {
                system = hostSystem;
              };
            }
          )
        )
      ) hosts;
    in
    {
      nixosConfigurations = lib.mapAttrs (hostName: hostConfiguration: hostConfiguration.system) outputs;

      system.stateVersion = stateVersion;
    };
}
