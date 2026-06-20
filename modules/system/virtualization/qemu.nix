{
  lib,
  config,
  ...
}:
let
  cfg = config._.system.virtualization.qemu;
in
{
  options = with lib; {
    _ = {
      system.virtualization.qemu = {
        enable = mkEnableOption "QEMU";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation.libvirtd.enable = true;
  };
}
