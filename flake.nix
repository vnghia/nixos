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
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      disko,
      impermanence,
      ...
    }@inputs:
    let
      lib = nixpkgs.lib;
    in
    {
      nixosConfigurations =
        lib.attrsets.concatMapAttrs
          (
            name: value:
            builtins.listToAttrs (
              lib.lists.forEach value.flavors (
                flavor:
                lib.attrsets.nameValuePair ("${name}${lib.optionalString (flavor != null) "-${flavor}"}") (
                  lib.nixosSystem {
                    specialArgs = { inherit inputs; };
                    modules = [
                      home-manager.nixosModules.home-manager
                      disko.nixosModules.disko
                      impermanence.nixosModules.impermanence

                      ./modules

                      ./hosts/${name}/${if flavor != null then flavor else "host"}
                    ];
                  }
                )
              )
            )
          )
          {
            lyoko = {
              flavors = [
                null
                "qemu"
              ];
            };
          };

      system.stateVersion = "26.05";
    };
}
