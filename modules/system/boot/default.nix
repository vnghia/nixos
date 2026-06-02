{
  lib,
  config,
  ...
}:
let
  cfg = config.system.boot;
in
{
  options = {
    system.boot = with lib; {
      type = mkOption { type = types.enum [ "systemd" ]; };
    };
  };

  config = lib.mkIf (cfg.type == "systemd") {
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = false;
  };
}
