{
  pkgs,
  ...
}:
{
  imports = [
    ./dns
    ./network-manager
    ./vpn
  ];

  config = {
    environment.systemPackages = with pkgs; [
      inetutils
    ];
  };
}
