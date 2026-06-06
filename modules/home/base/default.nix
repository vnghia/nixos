{
  lib,
  config,
  osConfig,
  pkgs,
  ...
}:
let
  cfg = config._.user;
  shellCfg = osConfig._.shell;
in
{
  options = with lib; {
    _ = {
      user = {
        name = mkOption {
          type = types.nullOr types.str;
          default = null;
        };
      };
    };
  };

  config = {
    home = lib.mkMerge [
      {
        shell = {
          enableZshIntegration = shellCfg.zsh.enable;
        };

        stateVersion = "26.05";
      }
      (lib.mkIf (cfg.name != null) {
        username = cfg.name;
        homeDirectory = "/home/${cfg.name}";
      })
    ];

    programs = {
      home-manager = {
        enable = true;
      };
    };
  };
}
