{
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./mt7921
  ];

  options = with lib; {
    _ = {
      system.hardware.network = {
        hardwares = mkOption {
          type = types.listOf types.str;
          default = [ ];
        };
      };
    };
  };

  config = {
    environment.systemPackages = with pkgs; [
      iw
    ];
  };
}
