{
  lib,
  config,
  ...
}:
let
  cfg = config._.system.linux.kernel;
in
{
  options = with lib; {
    _ = {
      system.linux.kernel = mkOption {
        type = types.nullOr types.raw;
        default = null;
      };
    };
  };

  config = {
    boot.kernelPackages = lib.mkIf (cfg != null) cfg;
  };
}
