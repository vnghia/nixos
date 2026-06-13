{
  lib,
  config,
  ...
}:
let
  cfg = config._.network.dns;
in
{
  options = with lib; {
    _ = {
      network.dns = {
        nameservers = mkOption {
          type = types.listOf types.str;
        };
      };
    };
  };

  config = {
    networking.nameservers = cfg.nameservers;

    services.resolved = {
      enable = true;
      settings.Resolve = {
        Domains = [ "~." ];
        DNSOverTLS = true;
        DNSSEC = true;
      };
    };
  };
}
