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
          default = {
            type = "mullvad";
            enabledInterfaces = [ "wlan0" ];
          };
          tailscale = {
            enable = true;
          };
        };
      };
    };
  };
}
