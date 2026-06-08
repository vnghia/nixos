{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";

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
            null
            "qemu"
          ];
          users = {
            xana = "desktop";
          };
        };
      };

      mkHostName = name: flavor: "${name}${lib.optionalString (flavor != null) "-${flavor}"}";

      outputs = lib.attrsets.concatMapAttrs (
        name: value:
        lib.attrsets.mergeAttrsList (
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

                  { nixpkgs.overlays = [ nix-vscode-extensions.overlays.default ]; }

                  ./modules

                  ./hosts/${name}/${if flavor != null then flavor else "host"}
                  {
                    networking.hostName = hostName;
                    nixpkgs.hostPlatform = value.platform;
                  }
                  {
                    imports = lib.attrsets.mapAttrsToList (
                      userName: userFlavor: ./users/${userName}/${userFlavor}
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
      nixosConfigurations = lib.attrsets.mapAttrs (
        hostName: hostConfiguration: hostConfiguration.system
      ) outputs;

      system.stateVersion = stateVersion;
    };
}
