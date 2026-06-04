{
  lib,
  osConfig,
  ...
}:
let
  osCfg = osConfig._.user;
  shellCfg = osConfig._.shell;
in
{
  config = {
    home = {
      username = osCfg.name;
      homeDirectory = "/home/${osCfg.name}";
      shell = {
        enableZshIntegration = shellCfg.zsh.enable;
      };
    };

    programs = {
      home-manager = {
        enable = true;
      };
    };

    home.stateVersion = "26.05";
  };
}
