{
  customLib,
  config,
  ...
}:
let
  cfg = config._.desktop.frameworks.qt;
in
{
  options = {
    _ = {
      desktop = {
        frameworks = {
          qt = customLib.home.desktop.theming.stylix.mkOption;
        };
      };
    };
  };

  config = customLib.home.desktop.theming.stylix.mkConfig "qt" cfg;
}
