{
  pkgs,
  ...
}:
{
  imports = [
    ./network

    ./bluetooth.nix
  ];

  config = {
    hardware.enableRedistributableFirmware = true;

    environment.systemPackages = with pkgs; [
      pciutils
    ];
  };
}
