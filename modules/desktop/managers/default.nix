{
  imports = [
    ./gnome.nix
  ];

  config = {
    _ = {
      nixos.impermanence = {
        directories = {
          # Desktop session data
          "/var/lib/AccountsService" = { };
          "/var/lib/cups" = { };
        };
      };
    };
  };
}
