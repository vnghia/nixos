{
  lib,
  config,
  osConfig,
  ...
}:
let
  cfg = config._.user;
  shellCfg = osConfig._.shell;
  xdgCfg = config.xdg;
in
{
  imports = [
    ./cli
    ./desktop
    ./nixos
    ./services
    ./shell
    ./specialisation
    ./user
    ./virtualisation
  ];

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

    _ = {
      nixos.impermanence.directories = {
        "${xdgCfg.dataHome}/systemd/timers" = { };
      };
    };
  };
}
