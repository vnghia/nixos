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
  xdgCfg = config.xdg;
  homeSpecialisationDirectory = "${xdgCfg.stateHome}/home-manager/gcroots/current-home/specialisation";
  specialisationDirectory = "${xdgCfg.stateHome}/specialisation";
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

    systemd.user.services.link-specialisation = {
      Unit = {
        Description = "Link specialisation to ${specialisationDirectory}";
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
      Service = {
        Type = "oneshot";
        ExecStart = "${pkgs.writeShellScript "link-specialisation" ''
          mkdir -p ${specialisationDirectory}
          for specialisation in $(find ${homeSpecialisationDirectory} -mindepth 1 -maxdepth 1 -type l); do
            name=${specialisationDirectory}/$(basename $specialisation)
            echo "Linking $specialisation to $name ..."
            rm $name
            ln -s $(realpath $specialisation) $name
          done
        ''}";
      };
    };
  };
}
