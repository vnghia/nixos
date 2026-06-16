{
  pkgs,
  ...
}:
{
  imports = [
    ./bluetooth
  ];

  config = {
    hardware.enableRedistributableFirmware = true;

    environment.systemPackages = with pkgs; [
      pciutils
    ];
  };
}
