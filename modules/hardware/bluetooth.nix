{
  lib,
  config,
  ...
}:
let
  cfg = config._.hardware.bluetooth;
in
{
  options = with lib; {
    _ = {
      hardware.bluetooth = {
        enable = mkEnableOption "Bluetooth";
        onBoot = mkEnableOption "On boot";
        config = {
          experimental = mkEnableOption "Experimental";
          fastConnectable = mkEnableOption "Fast connectable";
        };
      };
    };
  };

  config = {
    hardware.bluetooth = {
      enable = cfg.enable;
      powerOnBoot = cfg.onBoot;
      settings = {
        General = {
          Experimental = cfg.config.experimental;
          FastConnectable = cfg.config.fastConnectable;
        };
      };
    };
  };
}
