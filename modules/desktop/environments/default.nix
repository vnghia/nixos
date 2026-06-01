{
  imports = [
    ./gnome
  ];

  config = {
    system.nixos.impermanence = {
      directories = [
        # Desktop session data
        "/var/lib/AccountsService"
        "/var/cache/cups"
      ];
    };
  };
}
