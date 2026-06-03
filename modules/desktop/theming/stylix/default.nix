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
        image = mkOption {
          type = types.nullOr types.path;
          default = null;
        };
      };
    };
  };

  config = {
    stylix = {
      enable = true;
      autoEnable = false;
      overlays.enable = true;
      image = cfg.image;
    };
  };
}
