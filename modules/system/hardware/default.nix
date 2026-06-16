{
  pkgs,
  ...
}:
{
  hardware.enableRedistributableFirmware = true;

  environment.systemPackages = with pkgs; [
    pciutils
  ];
}
