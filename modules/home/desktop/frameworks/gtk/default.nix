{
  customLib,
  config,
  ...
}:
let
  cfg = config._.desktop.frameworks.gtk;
in
{
  options = {
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
