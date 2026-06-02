{
  lib,
  config,
  ...
}:
let
  cfg = config._.system.boot;
in
{
  options = with lib; {
    _ = {
      system.boot = {
        type = mkOption { type = types.enum [ "systemd" ]; };
      };
    };
  };

  config = lib.mkIf (cfg.type == "systemd") {
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = false;
  };
}
