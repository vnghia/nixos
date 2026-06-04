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

      stateVersion = "26.05";
    };

    programs = {
      home-manager = {
        enable = true;
      };
    };
  };
}
