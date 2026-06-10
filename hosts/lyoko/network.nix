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
          default = "mullvad";
          enabledInterfaces = [ "wlan0" ];
          tailscale = {
            enable = true;
          };
        };
      };
    };
  };
}
