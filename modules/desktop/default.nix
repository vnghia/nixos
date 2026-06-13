{
  lib,
  config,
  ...
}:
let
  managersCfg = config._.desktop.managers;
in
{
  imports = [
    ./frameworks
    ./fonts
    ./managers
    ./theming
  ];

  options = with lib; {
    _ = {
      desktop = {
        enable = mkOption {
          type = types.bool;
          default = managersCfg.gnome.enable;
        };
      };
    };
  };
}
