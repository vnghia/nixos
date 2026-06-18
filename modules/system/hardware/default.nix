{
  pkgs,
  ...
}:
{
  imports = [
    ./bluetooth
    ./network
  ];

  config = {
    hardware.enableRedistributableFirmware = true;

    environment.systemPackages = with pkgs; [
      pciutils
    ];
  };
}
