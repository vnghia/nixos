{
  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-26.05";
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
      url = "github:nix-community/lanzaboote/v1.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake/beta";
      inputs = {
        nixpkgs.follows = "nixpkgs";
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
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      disko,
      impermanence,
      stylix,
      lanzaboote,
      zen-browser,
      nix-vscode-extensions,
      sops-nix,
      ...
    }@inputs:
    let
      stateVersion = "26.05";

      lib = nixpkgs.lib;
      customLib = (import ./lib) {
        inherit lib;
      };

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
              hostName = mkHostName name flavor;
              hostSystem = lib.nixosSystem {
                specialArgs = {
                  inherit inputs;
                  inherit customLib;
                };
                modules = [
                  home-manager.nixosModules.home-manager
                  disko.nixosModules.disko
                  impermanence.nixosModules.impermanence
                  stylix.nixosModules.stylix
                  lanzaboote.nixosModules.lanzaboote
                  sops-nix.nixosModules.sops

                  { nixpkgs.overlays = [ nix-vscode-extensions.overlays.default ]; }

                  ./modules

                  ./hosts/${name}/${flavor}
                  {
                    networking.hostName = hostName;
                    nixpkgs.hostPlatform = value.platform;
                  }
                  {
                    imports = lib.mapAttrsToList (userName: userFlavor: ./users/${userName}/${userFlavor}) value.users;
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
