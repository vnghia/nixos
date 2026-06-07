{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config._.desktop.frameworks.gtk;
in
{
  options = with lib; {
    _ = {
      desktop = {
        frameworks = {
          gtk = {
            stylix = mkEnableOption "Stylix";
          };
        };
      };
    };
  };

  config = {
    stylix.targets.gtk.enable = cfg.stylix;
  };
}
