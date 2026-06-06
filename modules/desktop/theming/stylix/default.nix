{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config._.desktop.theming.stylix;
in
{
  options = with lib; {
    _ = {
      desktop.theming.stylix = {
        scheme = mkOption {
          type = types.str;
          default = "blueish";
        };
      };
    };
  };

  config = {
    stylix = {
      enable = true;
      autoEnable = false;
      overlays.enable = true;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/${cfg.scheme}.yaml";
    };
  };
}
