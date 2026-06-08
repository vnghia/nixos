{
  lib,
  config,
  ...
}:
let
  cfg = config._.desktop.frameworks.qt;
in
{
  options = with lib; {
    _ = {
      desktop = {
        frameworks = {
          qt = {
            stylix = mkEnableOption "Stylix";
          };
        };
      };
    };
  };

  config = {
    stylix.targets.qt.enable = cfg.stylix;
  };
}
