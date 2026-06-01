{
  imports = [
    ./gnome
  ];

  config = {
    impermanence = {
      directories = [
        # Desktop session data
        "/var/lib/AccountsService"
        "/var/cache/cups"
      ];
    };
  };
}
