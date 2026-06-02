{
  lib,
  osConfig,
  ...
}:
let
  osCfg = osConfig._.user;
in
{
  config = {
    home = {
      username = osCfg.name;
      homeDirectory = "/home/${osCfg.name}";
    };

    programs.home-manager.enable = true;

    home.stateVersion = "26.05";
  };
}
