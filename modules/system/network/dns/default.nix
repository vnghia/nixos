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
        interfaceConfig = mkOption {
          type = types.attrsOf (
            types.submodule {
              options = {
                connections = mkOption {
                  type = types.listOf types.str;
                };
                domains = mkOption {
                  type = types.listOf types.str;
                };
                dnsOverTls = mkOption {
                  type = types.bool;
                  default = true;
                };
              };
            }
          );
          default = { };
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
