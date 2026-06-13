{
  secrets,
  ...
}:
{
  config = {
    _ = {
      network = {
        dns = {
          nameservers = secrets.network.dns.nameservers;
        };
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
            interfaceTrustedConnections = builtins.fromJSON secrets.network.vpn.interfaceTrustedConnections;
          };
          tailscale = {
            enable = true;
          };
        };
      };
    };
  };
}
