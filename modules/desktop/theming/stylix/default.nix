{
  lib,
  config,
  ...
}:
let
  cfg = config._.desktop.theming.stylix;
in
{
  options = with lib; {
    _ = {
      desktop.theming.stylix = {
        enable = mkEnableOption "Stylix";
        image = mkOption {
          type = types.nullOr types.path;
          default = null;
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    stylix = {
      enable = true;
      image = cfg.image;
    };
  };
}
