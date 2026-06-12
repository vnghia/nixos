{
  config = {
    networking.nameservers = [
      "1.1.1.1"
    ];

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
