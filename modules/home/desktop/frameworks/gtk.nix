{
  lib,
  customLib,
  config,
  ...
}:
let
  cfg = config._.desktop.frameworks.gtk;
  xdgCfg = config.xdg;
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

  config = lib.mkMerge [
    (customLib.home.desktop.theming.stylix.mkConfig "gtk" cfg)
    {
      _ = {
        nixos.impermanence.files = {
          # Connected servers
          "${xdgCfg.configHome}/gtk-4.0/servers" = { };
        };
      };
    }
  ];
}
