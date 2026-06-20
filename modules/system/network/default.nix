{
  pkgs,
  ...
}:
{
  imports = [
    ./vpn

    ./dns.nix
    ./network-manager.nix
  ];

  config = {
    environment.systemPackages = with pkgs; [
      inetutils
    ];
  };
}
