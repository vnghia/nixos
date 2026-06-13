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
          interfaceConfig = builtins.fromJSON secrets.network.dns.interfaceConfig;
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
