{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
    in
    {
      nixosConfigurations = {
        lyoko = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [ ./nixos/configuration.nix ];
        };
      };
    };
}
