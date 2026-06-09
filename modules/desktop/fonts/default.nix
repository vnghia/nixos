{
  lib,
  config,
  ...
}:
let
  cfg = config._.desktop.fonts;
in
{
  options = with lib; {
    _ = {
      desktop.fonts = mkOption {
        type = types.listOf types.package;
        default = [ ];
      };
    };
  };

  config = {
    fonts.packages = cfg;
  };
}
