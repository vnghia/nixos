{
  lib,
  osConfig,
  ...
}:
let
  osCfg = osConfig.user;
in
{
  config = {
    home = {
      username = osCfg.username;
      homeDirectory = "/home/${osCfg.username}";
    };

    programs.home-manager.enable = true;

    home.stateVersion = "26.05";
  };
}
