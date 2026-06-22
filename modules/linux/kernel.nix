{
  lib,
  config,
  ...
}:
let
  cfg = config._.linux.kernel;
in
{
  options = with lib; {
    _ = {
      linux.kernel = mkOption {
        type = types.nullOr types.raw;
        default = null;
      };
    };
  };

  config = {
    boot.kernelPackages = lib.mkIf (cfg != null) cfg;
  };
}
