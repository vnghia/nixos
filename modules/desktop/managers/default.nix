{
  imports = [
    ./gnome
  ];

  config = {
    _ = {
      system.nixos.impermanence = {
        directories = [
          # Desktop session data
          "/var/lib/AccountsService"
          "/var/lib/cups"
        ];
      };
    };
  };
}
