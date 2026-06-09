{
  config = {
    _ = {
      network = {
        networkManager = {
          enable = true;
          wifi = {
            backend = "iwd";
          };
        };
        vpn = {
          mullvad = {
            enable = true;
          };
        };
      };
    };
  };
}
