{
  secrets,
  ...
}:
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
            enabledInterfaces = secrets.network.vpn.enabledInterfaces;
            trustedConnections = secrets.network.vpn.trustedConnections;
          };
          tailscale = {
            enable = true;
          };
        };
      };
    };
  };
}
