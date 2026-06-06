{
  lib,
  customLib,
  config,
  osConfig,
  pkgs,
  ...
}:
let
  cfg = config._.specialisation;
  xdgCfg = config.xdg;
  homeSpecialisationDirectory = "${xdgCfg.stateHome}/home-manager/gcroots/current-home/specialisation";
  specialisationDirectory = "${xdgCfg.stateHome}/specialisation";
in
{
  options = with lib; {
    _ = {
      specialisation = mkOption {
        type = types.attrsOf (types.attrsOf (types.attrsOf types.anything));
        default = { };
      };
    };
  };

  config = {
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

    specialisation = lib.attrsets.concatMapAttrs (
      typeName: typeSpecialisation:
      (lib.attrsets.mapAttrs' (
        subName: subConfig:
        lib.attrsets.nameValuePair "${typeName}-${subName}" {
          configuration = customLib.mkForceRecursive subConfig;
        }
      ) typeSpecialisation)
    ) cfg;
  };
}
