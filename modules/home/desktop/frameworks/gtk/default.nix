{
  lib,
  customLib,
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
          gtk = customLib.home.desktop.theming.stylix.mkOption;
        };
      };
    };
  };

  config = customLib.home.desktop.theming.stylix.mkConfig "gtk" cfg;
}
